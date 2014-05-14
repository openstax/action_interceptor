ActionInterceptor.configure do
  # intercepted_url_key(key)
  # Type: Method
  # Arguments: the key (Symbol)
  # The parameter/session variable that will hold the intercepted URL
  # Default: :r
  intercepted_url_key :r

  # interceptor(interceptor_name, filter_name = nil, &block)
  # Type: Method
  # Arguments: interceptor name (Symbol or String),
  #            filter_name (Symbol or String),
  #            &block (Proc)
  # Defines an interceptor
  # Default: none
  # Example: Interception that will redirect to :my_action in UsersController
  # interceptor :my_name, :my_interception do
  #   redirect_to my_action_users_url if some_condition
  # end
end
