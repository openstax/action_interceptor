module ActionInterceptor
  class Interceptor

    # This class is just a Hash factory
    def self.new(interceptor_name, filter_name = nil, &block)
      # The default filter name is the interceptor name
      fname ||= filter_name || interceptor_name.to_sym

      # The default block will raise UndefinedInterception
      block ||= lambda { raise UndefinedInterception }

      {:filter_name => fname,
       :block       => block}
    end

  end
end
