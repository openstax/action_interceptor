require 'spec_helper'

module ActionInterceptor
  module Strategies
    describe Session do

      let!(:request)    {
        ::ActionController::TestRequest.new(:host => 'http://test.me')
      }
      let!(:controller) {
        c = ::ActionController::Base.new
        c.request = request
        c
      }
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
