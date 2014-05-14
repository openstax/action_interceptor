require 'action_interceptor/engine'
require 'action_interceptor/interceptor'

module ActionInterceptor
  mattr_reader :intercepted_url_key

  def self.intercepted_url_key(key = nil)
    return @intercepted_url_key || :r unless key
    @intercepted_url_key = key
  end

  def self.interceptors
    @interceptors ||= {}
  end

  def self.interceptor(interceptor_name, filter_name = nil, &block)
    i = Interceptor.new(interceptor_name, filter_name, &block)
    interceptors.merge!({interceptor_name => i})
  end

  def self.configure(&block)
    instance_exec &block
  end
end
