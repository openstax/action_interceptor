module ActionInterceptor
  module Common

    protected

    def url_for(options = {})
      url = super
      return url unless use_interceptor

      @interceptor_url_for_hash ||= is_interceptor ? \
                                    intercepted_url_hash : current_url_hash

      uri = URI(url)
      new_query = URI.decode_www_form(uri.query || '') + \
                    @interceptor_url_for_hash.to_a
      uri.query = URI.encode_www_form(new_query)
      uri.to_s
    end

    # Executes the given block as if it was inside an interceptor
    def with_interceptor(&block)
      previous_use_interceptor = use_interceptor

      begin
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us
        self.use_interceptor = true

        # Execute the block as if it was defined in this controller
        instance_exec &block
      rescue LocalJumpError => e
        # Silently ignore `return` errors in the block
        # and return the given value
        e.exit_value
      ensure
        self.use_interceptor = previous_use_interceptor
      end
    end

    # Executes the given block as if it was not inside an interceptor
    def without_interceptor(&block)
      previous_use_interceptor = use_interceptor

      begin
        # Send the referer with intercepted requests
        # So we don't rely on the user's browser to do it for us
        self.use_interceptor = false

        # Execute the block as if it was defined in this controller
        instance_exec &block
      rescue LocalJumpError => e
        # Silently ignore `return` errors in the block
        # and return the given value
        e.exit_value
      ensure
        self.use_interceptor = previous_use_interceptor
      end
    end

  end
end
