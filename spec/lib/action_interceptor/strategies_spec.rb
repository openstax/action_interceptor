require 'spec_helper'
require 'dummy/lib/strategies/dummy'

module ActionInterceptor
  RSpec.describe Strategies, type: :lib do

    let!(:controller) { ::ActionController::Base.new }

    it 'registers and instantiates storage strategies' do
      described_class.register(:dummy, ::Strategies::Dummy)
      strategy = described_class.find(controller, :dummy)
      expect(strategy).to be_a ::Strategies::Dummy
      expect(strategy.controller).to eq controller

      strategies = described_class.find_all(controller, [:dummy])
      strategies.each do |strat|
        expect(strat).to be_a ::Strategies::Dummy
        expect(strat.controller).to eq controller
      end
    end

  end
end
