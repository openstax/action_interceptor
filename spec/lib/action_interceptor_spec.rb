require 'spec_helper'

describe ActionInterceptor do
  it 'must be configurable' do
    expect(described_class.config.default_url).to eq('/dummy')
    expect(described_class.config.default_key).to eq(:dummy_key)
  end
end
