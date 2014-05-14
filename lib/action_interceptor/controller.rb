require 'public_suffix'
require 'action_interceptor/interceptor'

module ActionInterceptor
  module Controller

    def self.included(base)
      base.class_attribute :is_interceptor
      base.is_interceptor = false
      base.extend(ClassMethods)
    end

    protected

    def redirect_to(options = {}, response_status = {})
      # Send the referer with intercepted requests
      # So we don't rely on the browser to do it for us
      if @intercepted_url_key
        # Can't redirect back to non-get
        intercepted_url = request.get? ? current_url : root_url
        intercepted_url_hash = {@intercepted_url_key => intercepted_url}

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

    def local_url?(url)
      # Blank is local
      return true if url.blank?

      url_host = URI(url).host
      request_host = request.host

      # Looking up the domain on the Public Suffix List is necessary to handle
      # servers in multiple subdomains
      begin
        PublicSuffix.parse(url_host).domain == PublicSuffix.parse(request_host).domain
      rescue PublicSuffix::DomainInvalid
        # We most likely got here because we are using IP addresses instead of
        # named hosts (dev environment). So just do a direct comparison.
        url_host == request_host
      end
    end

    module ClassMethods

      def intercept_with(controller, interceptor_name, options = {}, &block)
        controller = controller.to_s if controller.is_a? Symbol
        controller = controller.classify.constantize if controller.is_a? String
        interceptor = Interceptor.get(controller, interceptor_name)

        key = interceptor[:intercepted_url_key]
        fname = options.delete(:filter_name) || interceptor[:filter_name]
        block ||= interceptor[:block]

        before_filter fname, options

        define_method fname do
          @intercepted_url_key = key
          begin
            # Execute the block as if it was defined in this controller
            block.bind(self).call
          ensure
            @intercepted_url_key = nil
          end
        end
      end

      def skip_intercept_with(controller, interceptor_name, options = {})
        fname = options.delete(:filter_name)
        
        unless fname
          controller = controller.to_s if controller.is_a? Symbol
          controller = controller.classify.constantize if controller.is_a? String

          fname = controller.get_interceptor(interceptor_name)[:filter_name]
        end

        skip_before_filter fname, options
      end

      def acts_as_interceptor
        return if is_interceptor
        self.is_interceptor = true

        class_eval do

          helper_method :intercepted_url

          def self.add_interceptor(interceptor_name, options = {}, &block)
            Interceptor.add(self, interceptor_name, options, &block)
          end

          def self.get_interceptor(interceptor_name)
            Interceptor.get(self, interceptor_name)
          end

          def url_options
            return @interceptor_url_options if @interceptor_url_options

            @interceptor_url_options = {}
            Interceptor.get_all(self).each do |interceptor_name, interceptor|
              intercepted_url = intercepted_url(interceptor_name)
              next unless intercepted_url
              intercepted_url_key = interceptor[:intercepted_url_key]
              @interceptor_url_options.merge!(
                {intercepted_url_key => intercepted_url})
            end
          end

          def intercepted_url(interceptor_name)
            @intercepted_urls ||= {}
            return @intercepted_urls[interceptor_name] \
              if @intercepted_urls[interceptor_name]

            key = self.class.get_interceptor(
                    interceptor_name)[:intercepted_url_key]
            unsafe_intercepted_url = params[key] || session[key] ||\
                                     request.referer || root_url
            session[key] = unsafe_intercepted_url

            # Only local return urls are allowed
            # Will point to root if non-local
            @intercepted_urls[interceptor_name] = \
              local_url?(unsafe_intercepted_url) ? \
                unsafe_intercepted_url : root_url
          end

          def redirect_from_interception(interceptor_name, options = {})
            intercepted_url = intercepted_url(interceptor_name)

            # Prevent self redirect
            redirect_to (current_page?(intercepted_url) ? \
                          root_url : intercepted_url), options
          end

          alias_method :redirect_from, :redirect_from_interception

        end
      end

    end

  end
end

ActionController::Base.send :include, ActionInterceptor::Controller
