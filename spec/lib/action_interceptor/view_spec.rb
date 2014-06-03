require 'spec_helper'

module ActionInterceptor
  describe View do

    it 'modifies ActionView::Base' do
      expect(ActionView::Base.new.respond_to?(
        :url_for, true)).to eq(true)
      expect(ActionView::Base.new.respond_to?(
        :with_interceptor, true)).to eq(true)
      expect(ActionView::Base.new.respond_to?(
        :without_interceptor, true)).to eq(true)
    end

  end
end
