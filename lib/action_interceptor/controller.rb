require 'action_interceptor/encryptor'
require 'action_interceptor/undefined_interceptor'

module ActionInterceptor
  module Controller

    def self.included(base)
      base.class_attribute :is_interceptor, :interceptor_filters
      base.is_interceptor = false
      base.interceptor_filters = {}
      base.extend(ClassMethods)
    end

    protected

    def current_url
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end

    def current_page?(url)
      # Blank is the current page
      url.blank? || URI(url).path == request.path
    end

    def current_url_hash
      return @current_url_hash if @current_url_hash

      key = ActionInterceptor.intercepted_url_key

      # Can't redirect back to non-get
      # Also, can't call root_url here, so use '/' instead
      url = Encryptor.encrypt_and_sign(request.get? ? current_url : '/')
      @current_url_hash = {key => url}
    end

    # Executes the given block as if it was an interceptor
    def with_interceptor(&block)
      @previous_default_url_options ||= default_url_options

      begin
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us
        self.default_url_options = @previous_default_url_options
                                     .merge(current_url_hash)

        # Execute the block as if it was defined in this controller
        instance_exec &block
      rescue LocalJumpError => e
        # Silently ignore `return` errors in the block
        # and return the given value
        e.exit_value
      ensure
        self.default_url_options = @previous_default_url_options
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

      def acts_as_interceptor(options = {})
        return if is_interceptor
        self.is_interceptor = true

        class_eval do

          helper_method :intercepted_url

          def intercepted_url
            return @intercepted_url if @intercepted_url

            key = ActionInterceptor.intercepted_url_key
            begin
              # URL params are the most reliable, as they preserve
              # state even if the user presses the back button
              # Prevent Open Redirect vulnerability
              @intercepted_url = Encryptor.decrypt_and_verify(params[key])
            rescue ActiveSupport::MessageVerifier::InvalidSignature
              # If the param is not available, use our best guess
              # Session and referer are safe for redirects (for that user)
              # Also, can't call root_url here, so use '/' instead
              @intercepted_url = session[key] || request.referer || '/'
            end
            # Session is a signed plaintext in Rails 3
            # In Rails 4, it is encrypted by default
            session[key] = @intercepted_url
            @intercepted_url
          end

          def intercepted_url_hash
            return @intercepted_url_hash if @intercepted_url_hash
            url = Encryptor.encrypt_and_sign(intercepted_url)
            key = ActionInterceptor.intercepted_url_key

            @intercepted_url_hash = {key => url}
          end

          alias_method :url_options_without_interceptor, :url_options

          def url_options_with_interceptor
            return @url_options_with_interceptor \
              if @url_options_with_interceptor

            @url_options_with_interceptor = intercepted_url_hash.merge(
                                              url_options_without_interceptor)
          end


          alias_method :url_options, :url_options_with_interceptor \
            unless !options[:override_url_options].nil? && \
                   !options[:override_url_options]

          def without_interceptor(&block)
            previous_url_options = url_options_with_interceptor

            begin
              @url_options_with_interceptor = url_options_without_interceptor
              yield block
            ensure
              @url_options_with_interceptor = previous_url_options
            end
          end

          def redirect_back(options = {})
            url = intercepted_url

            # Disable the return_to param
            without_interceptor do
              # Convert '/' back to root_url
              # Also, prevent self redirects
              url = root_url if url == '/' || current_page?(url)

              redirect_to url, options
            end
          end

        end
      end

    end

  end
end

ActionController::Base.send :include, ActionInterceptor::Controller
