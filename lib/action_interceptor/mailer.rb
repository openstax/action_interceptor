module ActionInterceptor
  module Mailer

    def self.included(base)
      base.helper_method :use_interceptor, :use_interceptor=
    end

    protected

    def use_interceptor
      false
    end

    def use_interceptor=(arg)
      false
    end

  end
end

ActionMailer::Base.send :include, ActionInterceptor::Mailer
