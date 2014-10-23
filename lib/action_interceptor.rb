require 'action_interceptor/engine'

module ActionInterceptor

  DEFAULT_CONFIG = {}

  INTERCEPTOR_ATTRIBUTES = [:intercepted_url_key,
                            :override_url_options,
                            :skip_session]

  INTERCEPTOR_ATTRIBUTES.each do |attribute|
    define_singleton_method(attribute) do |value|
      DEFAULT_CONFIG[attribute] = value
    end
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
