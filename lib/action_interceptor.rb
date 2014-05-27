require 'action_interceptor/engine'

module ActionInterceptor
  def self.intercepted_url_key(key = nil)
    @intercepted_url_key = key unless key.blank?
    @intercepted_url_key || :r
  end

  def self.override_url_options(bool = nil)
    @override_url_options = bool unless bool.nil?
    @override_url_options.nil? ? true : @override_url_options
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
