require 'spec_helper'

module ActionInterceptor
  describe View do

    it 'modifies ActionView::Base' do
      expect(ActionView::Base.new.respond_to?(
        :url_for, true)).to be_true
      expect(ActionView::Base.new.respond_to?(
        :with_interceptor, true)).to be_true
      expect(ActionView::Base.new.respond_to?(
        :without_interceptor, true)).to be_true
    end

  end
end
