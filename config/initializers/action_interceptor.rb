ActionInterceptor.configure do
  # The following options can be set in this initializer
  # or passed directly to acts_as_interceptor:

  # intercepted_url_key(key)
  # Type: Method
  # Arguments: key (Symbol)
  # The parameter/session variable that will hold the intercepted URL.
  # Default: :r
  intercepted_url_key :r

  # override_url_options(bool)
  # Type: Method
  # Arguments: bool (Boolean)
  # If true, the url_options method will be overriden for any controller that
  # `acts_as_interceptor`. This option causes all links and redirects from any
  # such controller to include a parameter containing the intercepted_url_key
  # and the intercepted url.
  # If set to false, you must use the interceptor_url_options method to obtain
  # the hash and pass it to any links or redirects that need to use it.
  # Default: true
  override_url_options true

  # skip_session(bool)
  # Type: Method
  # Arguments: bool (Boolean)
  # If set to false, ActionInterceptor will store and use the intercepted url
  # in the session object, under the :interceptor key. ActionInterceptor will
  # attempt to retrieve the intercepted url from the url params, session and
  # referer, in this order.
  # If true, ActionInterceptor will ignore the session, so only the url params
  # and the referer will be checked, in this order.
  # Useful if you expect to get redirects that do not or cannot properly set
  # the url params and must rely on the referer instead.
  # Default: false
  skip_session false

  # The following options can only be set in this initializer:

  # interceptor(interceptor_name, &block)
  # Type: Method
  # Arguments: interceptor name (Symbol or String),
  #            &block (Proc)
  # Defines an interceptor.
  # Default: none
  # Example: interceptor :my_name do
  #            redirect_to my_action_users_url if some_condition
  #          end
  #
  #          (Conditionally redirects to :my_action in UsersController)
end
