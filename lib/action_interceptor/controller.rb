require 'action_interceptor/encryptor'

module ActionInterceptor
  module Controller

    def self.included(base)
      base.class_attribute :is_interceptor
      base.is_interceptor = false
      base.extend(ClassMethods)
    end

    protected

    def redirect_to(options = {}, response_status = {})
      if @interception_enabled
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us

        key = ActionInterceptor.intercepted_url_key
        # Can't redirect back to non-get
        url = Encryptor.encrypt_and_sign(request.get? ? current_url : root_url)
        intercepted_url_hash = {key => url}

        if options.is_a? Hash
          options = intercepted_url_hash.merge(options)
        else
          response_status = intercepted_url_hash.merge(response_status)
        end
      end

      super
    end

    def current_url
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end

    def current_page?(url)
      # Blank is the current page
      url.blank? || URI(url).path == request.path
    end

    module ClassMethods

      def interception(interceptor_name, options = {}, &block)
        interceptor = ActionInterceptor.interceptors[interceptor_name]
        key = ActionInterceptor.intercepted_url_key

        fname = options.delete(:filter_name) || interceptor[:filter_name]
        block ||= interceptor[:block]

        before_filter fname, options

        define_method fname do
          begin
            @interception_enabled = true
            # Execute the block as if it was defined in this controller
            block.bind(self).call
          ensure
            @interception_enabled = nil
          end
        end
      end

      def skip_interception(interceptor_name, options = {})
        fname = options.delete(:filter_name)
        
        unless fname
          fname = ActionInterceptor.interceptors[interceptor_name][:filter_name]
        end

        skip_before_filter fname, options
      end

      def acts_as_interceptor
        return if is_interceptor
        self.is_interceptor = true

        class_eval do

          helper_method :intercepted_url

          def url_options
            return @interceptor_url_options if @interceptor_url_options

            url = Encryptor.encrypt_and_sign(intercepted_url)
            key = ActionInterceptor.intercepted_url_key
            @interceptor_url_options = {key => url}.merge(super)
          end

          def intercepted_url
            return @intercepted_url if @intercepted_url

            key = ActionInterceptor.intercepted_url_key
            begin
              # URL params are the most reliable, as they preserve
              # state even if the user presses the back button
              # Prevent Open Redirect vulnerability
              @intercepted_url ||= Encryptor.decrypt_and_verify(params[key])
            rescue ActiveSupport::MessageVerifier::InvalidSignature
              # If the param is not available, take our best guess
              # Session, referer and root are safe
              @intercepted_url ||= session[key] || request.referer || root_url
            end
            session[key] = @intercepted_url
            @intercepted_url
          end

          def redirect_back(options = {})
            url = intercepted_url

            # Prevent self redirect
            redirect_to (current_page?(url) ? root_url : url), options
          end

        end
      end

    end

  end
end

ActionController::Base.send :include, ActionInterceptor::Controller
