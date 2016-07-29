require 'action_interceptor/strategies'

module ActionInterceptor
  module Strategies
    class Session

      def initialize(controller)
        @session = controller.session
      end

      def set(key, string)
        @session[key] = string
      end

      def get(key)
        @session[key]
      end

      def unset(key)
        @session.delete(key)
      end

    end
  end
end

ActionInterceptor::Strategies.register(:session, ActionInterceptor::Strategies::Session)
