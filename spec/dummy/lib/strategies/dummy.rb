module Strategies
  class Dummy

    attr_reader :controller

    def initialize(controller)
      @controller = controller
      @url = {}
    end

    def set(key, string)
      @url[key] = string
    end

    def get(key)
      @url[key]
    end

    def unset(key)
      @url.delete(:key)
    end

  end
end
