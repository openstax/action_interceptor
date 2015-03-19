module ActionInterceptor
  module ActionController
    module Base

      def self.included(base)
        base.helper_method :current_page?, :current_url, :stored_url
      end

      def current_page?(url)
        # Return true for blank (blank links redirect to the same page)
        url.blank? || URI(url).path == request.path
      end

      def current_url
        "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      end

      # Stores the given url or the current url
      def store_url(options = {})
        strats = ActionInterceptor::Strategies.find_all(self,
                                                        options[:strategies])
        key = options[:key] || ActionInterceptor.config.default_key

        url = options[:url] || current_url

        strats.each do |strat|
          strat.set(key, url)
        end
      end

      # Retrieves the stored url
      def stored_url(options = {})
        strats = ActionInterceptor::Strategies.find_all(self,
                                                        options[:strategies])
        key = options[:key] || ActionInterceptor.config.default_key

        strats.each do |strat|
          url = strat.get(key)
          return url unless url.blank?
        end

        nil
      end

      # Deletes to the stored url
      def delete_stored_url(options = {})
        store_url(options.merge(url: nil))
      end

      # Redirects to the stored url and deletes it from storage
      def redirect_back(options = {})
        interceptor_options = options.slice(:key, :strategies)
        redirect_options = options.except(:key, :strategies)

        url = stored_url(interceptor_options)
        delete_stored_url(interceptor_options)

        # Prevent self redirects
        url = (ActionInterceptor.config.default_url || root_url) \
                if current_page?(url)

        redirect_to url, redirect_options
      end

    end
  end
end

ActionController::Base.send :include, ActionInterceptor::ActionController::Base
