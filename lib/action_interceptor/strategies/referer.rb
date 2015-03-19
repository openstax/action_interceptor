require 'action_interceptor/strategies'

module ActionInterceptor
  module Strategies
    class Referer

      def initialize(controller)
        @referer = controller.request.referer
      end

      def set(key, string)
        false
      end

      def get(key)
        @referer
      end

    end
  end
end

ActionInterceptor::Strategies.register(:referer,
                                       ActionInterceptor::Strategies::Referer)
