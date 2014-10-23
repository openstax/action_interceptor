ActionInterceptor.configure do
  intercepted_url_key :dummy_key

  override_url_options true

  skip_session false

  interceptor :registration do
  end

  interceptor :my_interceptor do
  end
end
