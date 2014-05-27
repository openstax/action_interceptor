# Action Interceptor

[![Build Status](https://travis-ci.org/openstax/action_interceptor.svg?branch=master)](https://travis-ci.org/openstax/action_interceptor)

[![Code Climate](https://codeclimate.com/github/openstax/action_interceptor.png)](https://codeclimate.com/github/openstax/action_interceptor)

Action Interceptor is a Rails engine that makes it easy to have controllers intercept
actions from other controllers, have users perform a task and then return them to where
they were when the interception happened.

This can be used, for example, for registration, authentication, signing terms of use, etc.

## Installation

Add this line to your application's Gemfile:

```rb
gem 'action_interceptor'
```

And then execute:

```sh
$ bundle install
```

Finally, run the following rake task to add
Action Interceptor's initializer to your application:

```sh
$ rake action_interceptor:install
```

## Usage

Interceptors are blocks of code that are declared in Action Interceptor's
initializer. They execute in the context of your controllers and work
very much like before_filters.

For example, the following interceptor could be used to ensure that users
have filled out a registration form:

```rb
interceptor :registration do

  return if current_user.try(:is_registered?)

  respond_to do |format|
    format.html { redirect_to register_path }
    format.json { head(:forbidden) }
  end

end
```

What makes interceptors different from before_filters is that they will
save the user's current url before redirecting. This is done through
signed url params by default, falling back to session variables if those
params are absent or invalid.

Once declared, you can use an interceptor in any controller. For example,
you might want to ensure that all logged in users have to complete
a form before using your site. In that case, you could add the following
to your `ApplicationController`:

```rb
class ApplicationController < ActionController::Base

  interceptor :registration

end
```

The controllers your interceptors redirect to should
call the `acts_as_interceptor` method:

```rb
class RegistrationsController < ApplicationController

  acts_as_interceptor

  skip_interceptor :registration, only: [:new, :create]

end
```

As shown above, interceptions work like before_filters and
can be skipped using the skip_interceptor method.

The `acts_as_interceptor` method will ensure the following:

- The `url_options` method for that controller will be overriden, causing all
  links and redirects for the controller and associated views to include
  the signed return url. This can be skipped by calling `acts_as_interceptor`
  like this: `acts_as_interceptor override_url_options: false`. In that case,
  you are responsible for passing the `intercepted_url_hash` to any internal
  links and redirects.

- The following convenience methods will be added to the controller:
  `redirect_back(options = {})`, `intercepted_url`, `intercepted_url=`,
  `intercepted_url_hash`, `without_interceptor(&block)`,
  `url_options_without_interceptor` and `url_options_with_interceptor`.
  These methods have the following behavior:

  - redirect_back(options = {}) redirects the user back to where the
    interception occurred, passing the given options to the redirect method.

  - `intercepted_url` returns the intercepted url. Can be used in views to make
    links that redirect the user back to where the interception happened.

  - `intercepted_url=` can be used to overwrite the intercepted url, if needed.

  - `intercepted_url_hash` returns a hash containing the `interceptor_url_key`
    and the signed `intercepted_url`.

  - `without_interceptor(&block)` executes a block with the old url options.

  - `url_options_without_interceptor` returns the old url options.

  - `url_options_with_interceptor` returns the old url options merged with
    the `intercepted_url_hash`. Can be used even if you specified
    `override_url_options: false`.

When users complete the given task, use the following method to
redirect them back to where the interception occurred:

```rb
redirect_back
```

Alternatively, you can use `intercepted_url` in views:

```erb
<%= link_to 'Back', intercepted_url %>
```

Finally, just by including the gem in your app, the following convenience
methods will be added to all controllers: `current_url`, `current_url_hash`,
`current_page?(url)` and `with_interceptor(&block)`.

- `current_url` returns the current url.
- `current_url_hash` returns a hash containing the `intercepted_url_key` and the
  `current_url`, signed and encrypted.
- `current_page?(url)` returns true iif the given url is the `current_url`.
- `with_interceptor(&block)` executes the given block as if it was an
  interceptor for the current controller.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write specs for your feature
4. Implement your new feature
5. Test your feature (`rake`)
6. Commit your changes (`git commit -am 'Added some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

## Development Environment Setup

1. Use bundler to install all dependencies:

  ```sh
  $ bundle install
  ```

2. Load the schema:

  ```sh
  $ rake db:schema:load
  ```

  Or if the above fails:

  ```sh
  $ bundle exec rake db:schema:load
  ```

## Testing

To run all existing tests for Action Interceptor,
simply execute the following from the main folder:

```sh
$ rake
```

Or if the above fails:

```sh
$ bundle exec rake
```

## License

This gem is distributed under the terms of the MIT license.
See the MIT-LICENSE file for details.
