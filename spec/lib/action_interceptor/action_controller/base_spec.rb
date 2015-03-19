require 'spec_helper'

module ActionInterceptor
  module ActionController
    describe Base do

      it 'modifies ActionController::Base' do
        expect(::ActionController::Base.new.respond_to?(
          :current_page?, true)).to eq(true)
        expect(::ActionController::Base.new.respond_to?(
          :current_url, true)).to eq(true)
        expect(::ActionController::Base.new.respond_to?(
          :store_url, true)).to eq(true)
        expect(::ActionController::Base.new.respond_to?(
          :stored_url, true)).to eq(true)
        expect(::ActionController::Base.new.respond_to?(
          :delete_stored_url, true)).to eq(true)
        expect(::ActionController::Base.new.respond_to?(
          :redirect_back, true)).to eq(true)
      end

    end
  end
end
