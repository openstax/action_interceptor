require 'spec_helper'

module ActionInterceptor
  describe View do

    it 'modifies ActionView::Base' do
      expect(ActionView::Base.new).to respond_to(:with_interceptor)
      expect(ActionView::Base.new).to respond_to(:without_interceptor)
    end

  end
end
