require 'action_interceptor/engine'

module ActionInterceptor
  def self.intercepted_url_key(key = nil)
    return @intercepted_url_key || :r if key.nil?
    @intercepted_url_key = key
  end

  def self.override_url_options(bool = nil)
    return @override_url_options if bool.nil?
    @override_url_options = bool
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
