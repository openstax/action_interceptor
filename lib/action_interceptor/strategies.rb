module ActionInterceptor
  module Strategies

    def self.register(name, strategy_class)
      @strategy_map ||= HashWithIndifferentAccess.new
      @strategy_map[name] = strategy_class
    end

    def self.find(controller, name)
      @strategy_map[name].new(controller)
    end

    def self.find_all(controller, names)
      names ||= ActionInterceptor.config.default_strategies
      names.collect{|name| find(controller, name)}
    end

  end
end
