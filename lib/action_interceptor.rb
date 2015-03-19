require 'action_interceptor/engine'
require 'action_interceptor/configuration'
require 'action_interceptor/strategies'
require 'action_interceptor/strategies/session'

module ActionInterceptor

  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    yield config
  end

end
