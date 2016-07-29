require 'spec_helper'

module ActionInterceptor
  describe Configuration do

    let!(:config) { described_class.new }

    it 'stores configuration options' do
      expect(config.default_url).to be_nil
      expect(config.default_key).to be_nil

      config.default_url = '/url'
      config.default_key = :key

      expect(config.default_url).to eq('/url')
      expect(config.default_key).to eq(:key)
    end

  end
end
