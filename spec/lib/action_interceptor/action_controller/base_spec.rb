require 'spec_helper'

module ActionInterceptor
  module ActionController
    RSpec.describe Base, type: :lib do

      let!(:request)    do
        ::ActionController::TestRequest.new(
          { 'REQUEST_METHOD' => 'GET', 'HTTP_REFERER' => 'http://refer.er' },
          {},
          ::ActionController::Base
        ).tap { |request| request.host = 'test.me' }
      end
      let!(:controller) do
        ::ActionController::Base.new.tap { |controller| controller.request = request }
      end

      it 'modifies ActionController::Base' do
        expect(controller.respond_to?(:current_page?, true)).to eq true
        expect(controller.respond_to?(:current_url, true)).to eq true
        expect(controller.respond_to?(:store_url, true)).to eq true
        expect(controller.respond_to?(:stored_url, true)).to eq true
        expect(controller.respond_to?(:store_fallback, true)).to eq true
        expect(controller.respond_to?(:delete_stored_url, true)).to eq true
        expect(controller.respond_to?(:redirect_back, true)).to eq true
      end

      it "allows controllers to store and retrieve url's" do
        current_url = controller.send(:current_url)
        expect(controller.send(:current_page?, current_url)).to eq true
        referer = request.referer

        expect(controller.send(:current_page?, referer)).to eq false

        expect(controller.send(:stored_url)).to be_blank

        expect(controller.send(:store_url)).to eq current_url
        expect(controller.send(:stored_url)).to eq current_url

        expect(controller.send(:delete_stored_url)).to be_nil
        expect(controller.send(:stored_url)).to be_blank

        expect(controller.send(:store_fallback)).to eq referer
        expect(controller.send(:stored_url)).to eq referer

        expect(controller).to receive(:redirect_to) { |url| url }
        expect(controller.send(:redirect_back)).to eq(referer)
        expect(controller.send(:stored_url)).to be_blank

        expect(controller.send(:store_url)).to eq current_url
        expect(controller.send(:stored_url)).to eq current_url

        expect(controller.send(:store_fallback)).to eq nil
        expect(controller.send(:stored_url)).to eq current_url

        expect(controller).to receive(:redirect_to) { |url| url }
        expect(controller.send(:redirect_back)).to(
          eq ActionInterceptor.config.default_url
        )
        expect(controller.send(:stored_url)).to be_blank
      end

    end
  end
end
