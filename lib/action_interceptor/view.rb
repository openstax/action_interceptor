require 'action_interceptor/common'

module ActionInterceptor
  module View

    include Common

  end
end

ActionView::Base.send :include, ActionInterceptor::View
