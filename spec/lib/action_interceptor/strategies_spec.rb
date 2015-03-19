require 'spec_helper'
require 'dummy/lib/strategies/dummy'

module ActionInterceptor
  describe Strategies do

    let!(:controller) { ::ActionController::Base.new }

    it 'registers and instantiates storage strategies' do
      ActionInterceptor::Strategies.register(:dummy, ::Strategies::Dummy)
      strategy = ActionInterceptor::Strategies.find(controller, :dummy)
      expect(strategy).to be_a ::Strategies::Dummy
      expect(strategy.controller).to eq controller

      strategies = ActionInterceptor::Strategies.find_all(controller, [:dummy])
      strategies.each do |strategy|
        expect(strategy).to be_a ::Strategies::Dummy
        expect(strategy.controller).to eq controller
      end
    end

  end
end
