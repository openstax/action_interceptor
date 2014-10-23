module ActionInterceptor
  module ActionMailer

    def self.included(base)
      base.helper_method :interceptor_enabled, :interceptor_enabled=
    end

    protected

    def interceptor_enabled
      false
    end

    def interceptor_enabled=(arg)
      false
    end

  end
end

ActionMailer::Base.send :include, ActionInterceptor::ActionMailer
