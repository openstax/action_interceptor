# Action Interceptor

[![Gem Version](https://badge.fury.io/rb/action_interceptor.svg)](http://badge.fury.io/rb/action_interceptor)
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

Afterwards, run the following rake task to add
Action Interceptor's initializer to your application:

```sh
$ rake action_interceptor:install
```

In case Action Interceptor is completely unable to determine which page a user
came from (should rarely happen if properly configured), it will send the user
to your application or gem's root_url. So make sure it is defined:

```rb
root :to => 'some_controller#some_action'
```

Alternatively, you can always stub root_url in your
ApplicationController and make it a helper method.

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

Just by including the gem in your app, the following convenience methods
will also be added to all controllers as helper methods, so they will also
be available in views: `current_page?(url)`, `current_url`, `current_url_hash`,
`with_interceptor(&block)` and `without_interceptor(&block)`.

- `with_interceptor(&block)` executes the given block:
  - Adding the intercepted URL param to all links and redirects
  - As if it was declared in the context of `self`
- `without_interceptor(&block)` executes the given block:
  - With the default URL params for all links and redirects
  - As if it was declared in the context of `self`

- `current_url_hash` returns a hash containing the `intercepted_url_key` and the
  `current_url`, signed and encrypted.

- And the following methods, backported from Rails 4:
  - `current_url` returns the current url.
  - `current_page?(url)` returns true iif the given url is the `current_url`.

When called, the `acts_as_interceptor` method will ensure the following:

- The `url_options` method for that controller will be overriden, causing all
  links and redirects for the controller and associated views to include
  the signed return url. This behavior can be skipped by passing
  `:override_url_options => false` to the `acts_as_interceptor` call,
  like so: `acts_as_interceptor :override_url_options => false`.
  In that case, you are responsible for wrapping any internal links and
  redirects in `with_interceptor` blocks.

- The following convenience methods will be added to the controller:
  `redirect_back(options = {})`, `intercepted_url`,
  `intercepted_url=` and `intercepted_url_hash`.
  These methods have the following behavior:

  - redirect_back(options = {}) redirects the user back to where the
    interception occurred, passing the given options to the redirect method.

  - `intercepted_url` returns the intercepted url. Can be used in views to make
    links that redirect the user back to where the interception happened.

  - `intercepted_url=` can be used to overwrite the intercepted url, if needed.

  - `intercepted_url_hash` returns a hash containing the `interceptor_url_key`
    and the signed `intercepted_url`.

When users complete the given task, use the following method to
redirect them back to where the interception occurred:

```rb
redirect_back
```

Alternatively, you can use `intercepted_url` in views:

```erb
<%= link_to 'Back', intercepted_url %>
```

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
