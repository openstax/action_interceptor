require 'action_interceptor/engine'

module ActionInterceptor
  mattr_reader :intercepted_url_key

  def self.intercepted_url_key(key = nil)
    return @intercepted_url_key || :r unless key
    @intercepted_url_key = key
  end

  def self.interceptors
    @interceptors ||= {}
  end

  def self.interceptor(interceptor_name, &block)
    interceptors.merge!({interceptor_name => block})
  end

  def self.configure(&block)
    instance_exec &block
  end
end
