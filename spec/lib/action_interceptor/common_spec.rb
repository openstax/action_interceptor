require 'spec_helper'

module ActionInterceptor
  describe Common do

    it 'modifies ActionController::Base' do
      expect(::ActionController::Base.new.respond_to?(
        :url_for, true)).to eq(true)
      expect(::ActionController::Base.new.respond_to?(
        :with_interceptor, true)).to eq(true)
      expect(::ActionController::Base.new.respond_to?(
        :without_interceptor, true)).to eq(true)
    end

    it 'modifies ActionView::RoutingUrlFor' do
      ::ActionView::Base.send :include, ::ActionView::RoutingUrlFor

      expect(::ActionView::Base.new.respond_to?(
        :url_for, true)).to eq(true)
      expect(::ActionView::Base.new.respond_to?(
        :with_interceptor, true)).to eq(true)
      expect(::ActionView::Base.new.respond_to?(
        :without_interceptor, true)).to eq(true)
    end

  end
end
