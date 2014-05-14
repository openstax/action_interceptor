module ActionInterceptor
  class Interceptor

    def self.new(controller, name, options = {}, &block)
      # Instances of this class are just hashes
      controller_name = controller.controller_name
      intercepted_url_key = options[:intercepted_url_key] ||\
                            "#{controller_name}_#{name}_intercepted_url".to_sym
      filter_name  = options[:filter_name] ||\
                     "#{controller_name}_#{name}_interception".to_sym
      # The default block always redirects to the controller's 'new' action
      block ||= lambda { redirect_to url_for(:controller => controller_name,
                                             :action => :new) }

      {:intercepted_url_key => intercepted_url_key,
       :filter_name         => filter_name,
       :block               => block}
    end

    def self.get_all(controller)
      @interceptors ||= {}
      @interceptors[controller] ||= {}
    end

    def self.add(controller, name, options = {}, &block)
      get_all(controller).merge!(
        {name => new(controller, name, options, &block)})
    end

    def self.get(controller, name)
      get_all(controller)[name]
    end

  end
end
