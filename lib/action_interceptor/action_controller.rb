require 'action_interceptor/common'
require 'action_interceptor/encryptor'
require 'action_interceptor/undefined_interceptor'

module ActionInterceptor
  module ActionController

    def self.included(base)
      base.class_attribute :interceptor_config, :interceptor_filters
      base.interceptor_filters = {}

      base.send :attr_accessor, :interceptor_enabled

      base.before_filter :interceptor_setup

      base.helper_method :_compute_redirect_to_location,
                         :interceptor_enabled, :interceptor_enabled=,
                         :is_interceptor?, :current_page?,
                         :current_url, :current_url_hash, 

      base.extend(ClassMethods)
    end

    protected

    def _compute_redirect_to_location(*args, &block)
      url_for(super(*args, &block))
    end

    def is_interceptor?
      !interceptor_config.nil?
    end

    def current_page?(url)
      # Blank is the current page
      url.blank? || URI(url).path == request.path
    end

    def current_url
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end

    def current_url_hash
      return @current_url_hash if @current_url_hash

      key = interceptor_config[:intercepted_url_key]

      # Can't redirect back to non-get
      # Also, can't call root_url here, so use '/' instead
      url = Encryptor.encrypt_and_sign(request.get? ? current_url : '/')

      @current_url_hash = {key => url}
    end

    def interceptor_setup
      config = interceptor_config
      if is_interceptor?
        self.interceptor_enabled = interceptor_config[:override_url_options]
        session.delete(:interceptor) if interceptor_config[:skip_session]
      else
        self.interceptor_enabled = false
        session.delete(:interceptor)
      end
    end

    module ClassMethods

      def interceptor(*interceptor_names, &block)
        options = interceptor_names.extract_options!
        filter_name = options.delete(:filter_name)
        fnames = interceptor_names.collect do |iname|
          fname = filter_name || iname
          interceptor_filters[iname] = fname

          define_method fname do
            blk = block || ActionInterceptor.interceptors[iname]
            raise UndefinedInterceptor, iname unless blk

            with_interceptor &blk
          end

          fname
        end

        before_filter *fnames, options
      end

      def skip_interceptor(*interceptor_names)
        options = interceptor_names.extract_options!
        filter_name = options.delete(:filter_name)
        fnames = interceptor_names.collect do |iname|
          filter_name || interceptor_filters[iname] || iname
        end

        skip_before_filter *fnames, options
      end

      def acts_as_interceptor(opts = {})
        self.interceptor_config = ActionInterceptor::DEFAULT_CONFIG.merge(opts)

        class_exec do

          attr_writer :intercepted_url

          # Ensure that we always store the intercepted url
          before_filter :intercepted_url

          helper_method :intercepted_url, :intercepted_url_hash

          protected

          def intercepted_url
            return @intercepted_url if @intercepted_url

            key = interceptor_config[:intercepted_url_key]
            encrypted_url = params[key]
            session_hash = session[:interceptor] \
              unless interceptor_config[:skip_session]
            session_hash ||= {}

            begin
              # URL params are the most reliable, as they preserve
              # state even if the user presses the back button
              # We need to sign them to prevent the Open Redirect vulnerability
              @intercepted_url = Encryptor.decrypt_and_verify(encrypted_url)

              # If we got this far, the encrypted url is valid
              # (i.e. we signed it), so reuse it
              @intercepted_url_hash = {key => encrypted_url}
            rescue ActiveSupport::MessageVerifier::InvalidSignature
              # If the param is not available, use our best guess
              # Session and referer are safe for redirects (for that user)
              # Also, can't call root_url here, so use '/' instead
              @intercepted_url = session_hash[key] || request.referer || '/'
            end

            # Prevent self-redirect
            @intercepted_url = '/' if current_page?(@intercepted_url)

            # Session is a signed plaintext in Rails 3
            # In Rails 4, it is encrypted by default
            session[:interceptor] = session_hash.merge(
              key => @intercepted_url) unless interceptor_config[:skip_session]

            @intercepted_url
          end

          def intercepted_url_hash
            # Run intercepted_url to verify the params in case the
            # encrypted url is in there and can be reused
            unencrypted_url = intercepted_url
            return @intercepted_url_hash if @intercepted_url_hash

            url = Encryptor.encrypt_and_sign(unencrypted_url)
            key = interceptor_config[:intercepted_url_key]

            @intercepted_url_hash = {key => url}
          end

          def redirect_back(options = {})
            # Disable the return_to param
            without_interceptor do
              redirect_to intercepted_url, options
            end
          end

        end
      end

    end

  end
end

ActionController::Base.send :include, ActionInterceptor::ActionController
