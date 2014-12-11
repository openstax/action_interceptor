require 'action_interceptor/action_controller'

module ActionInterceptor
  module Common

    def self.included(base)
      base.alias_method_chain :url_for, :interceptor
    end

    def url_for_with_interceptor(options = {})
      url = url_for_without_interceptor(options)
      return url unless interceptor_enabled

      @interceptor_url_for_hash ||= is_interceptor? ? \
                                    intercepted_url_hash : \
                                    current_url_hash

      uri = URI(url)
      new_query = HashWithIndifferentAccess[
                    URI.decode_www_form(uri.query || '')
                  ].merge(@interceptor_url_for_hash)
      uri.query = URI.encode_www_form(new_query)
      uri.to_s
    end

    protected

    # Executes the given block as if it was inside an interceptor
    def with_interceptor(&block)
      previous_interceptor_enabled = interceptor_enabled

      begin
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us
        self.interceptor_enabled = true

        # Execute the block as if it was defined in this controller
        instance_exec &block
      rescue LocalJumpError => e
        # Silently ignore `return` errors in the block
        # and return the given value
        e.exit_value
      ensure
        self.interceptor_enabled = previous_interceptor_enabled
      end
    end

    # Executes the given block as if it was not inside an interceptor
    def without_interceptor(&block)
      previous_interceptor_enabled = interceptor_enabled

      begin
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us
        self.interceptor_enabled = false

        # Execute the block as if it was defined in this controller
        instance_exec &block
      rescue LocalJumpError => e
        # Silently ignore `return` errors in the block
        # and return the given value
        e.exit_value
      ensure
        self.interceptor_enabled = previous_interceptor_enabled
      end
    end

  end
end

ActionController::Base.send :include, ActionInterceptor::Common
ActionView::Base.send :include, ActionInterceptor::Common
ActionView::RoutingUrlFor.send :include, ActionInterceptor::Common \
  if defined?(ActionView::RoutingUrlFor)
