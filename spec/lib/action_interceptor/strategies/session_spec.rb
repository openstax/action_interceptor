require 'spec_helper'

module ActionInterceptor
  module Strategies
    RSpec.describe Session, type: :lib do

      let!(:request)    do
        ::ActionController::TestRequest.new({}, {}, ::ActionController::Base).tap do |request|
          request.host = 'test.me'
        end
      end
      let!(:controller) do
        ::ActionController::Base.new.tap { |controller| controller.request = request }
      end
      let!(:strategy)   { Session.new(controller) }
      let!(:key)        { :key }
      let!(:string)     { 'string' }

      it "stores and retrieves url's in the session" do
        expect(strategy.get(key)).to eq nil
        expect(strategy.set(key, string)).to eq string
        expect(strategy.get(key)).to eq string
        expect(strategy.unset(key)).to eq string
        expect(strategy.get(key)).to eq nil
      end

    end
  end
end
