require 'spec_helper'

describe ActionInterceptor do
  it 'must be configurable' do
    expect(ActionInterceptor.config.default_url).to eq('/dummy')
    expect(ActionInterceptor.config.default_key).to eq(:dummy_key)
  end
end
