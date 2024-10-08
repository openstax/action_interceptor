require 'addressable/uri'

module ActionInterceptor
  module ActionController
    module Base

      def self.included(base)
        base.helper_method :current_page?, :current_url, :stored_url
      end

      protected

      def current_page?(url)
        # Return true for blank (blank links redirect to the same page)
        return true if url.blank?

        uri = Addressable::URI.parse(url)
        uri.path == request.path && (
          uri.relative? || uri.host == request.host_with_port || (
            uri.host == request.host && uri.port == request.port
          )
        )

      end

      def current_url
        "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      end

      # Stores the given url or the current url
      # If the current request is not a GET request, stores the referer instead
      def store_url(options = {})
        strats = ActionInterceptor::Strategies.find_all(self, options[:strategies])
        key = options[:key] || ActionInterceptor.config.default_key

        url = options.has_key?(:url) ?
                options[:url] : (request.get? ? current_url : request.referer)

        strats.each{ |strat| strat.set(key, url) }

        url
      end

      # Retrieves the stored url
      def stored_url(options = {})
        strats = ActionInterceptor::Strategies.find_all(self, options[:strategies])
        key = options[:key] || ActionInterceptor.config.default_key

        strats.each do |strat|
          url = strat.get(key)
          return url unless url.blank?
        end

        nil
      end

      # Stores the given url or the referer if no stored url is present
      def store_fallback(options = {})
        store_url({url: request.referer}.merge(options)) \
          if stored_url(options).blank?
      end

      # Deletes to the stored url
      def delete_stored_url(options = {})
        strats = ActionInterceptor::Strategies.find_all(self, options[:strategies])
        key = options[:key] || ActionInterceptor.config.default_key

        strats.each do |strat|
          strat.unset(key)
        end

        nil
      end

      # Redirects to the stored url and deletes it from storage
      def redirect_back(options = {})
        interceptor_options = options.slice(:key, :strategies)
        redirect_options = options.except(:key, :strategies)

        url = stored_url(interceptor_options)
        delete_stored_url(interceptor_options)

        # Prevent self redirects
        url = (ActionInterceptor.config.default_url || main_app.root_url) if current_page?(url)

        redirect_to url, redirect_options
      end

    end
  end
end

ActiveSupport.on_load(:action_controller_base) do
  ActionController::Base.send :include, ActionInterceptor::ActionController::Base
end
