require 'spec_helper'

describe ActionInterceptor do
  it 'must be configurable' do
    expect(ActionInterceptor.intercepted_url_key).to eq(:dummy_key)
    expect(ActionInterceptor.override_url_options).to eq(true)
    expect(ActionInterceptor.interceptors.keys).to include(:registration)

    my_block = lambda { 'my_block' }

    ActionInterceptor.configure do
      intercepted_url_key :my_key
      override_url_options false
      interceptor :my_name, &my_block
    end

    expect(ActionInterceptor.intercepted_url_key).to eq(:my_key)
    expect(ActionInterceptor.override_url_options).to eq(false)
    expect(ActionInterceptor.interceptors).to include({:my_name => my_block})
  end
end
