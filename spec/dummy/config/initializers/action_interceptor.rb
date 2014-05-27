ActionInterceptor.configure do
  intercepted_url_key :dummy_key

  override_url_options true

  interceptor :registration do
    redirect_to registration_path unless true
  end

  interceptor :my_interceptor do
  end
end
