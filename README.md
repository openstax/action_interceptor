# Action Interceptor

[![Build Status](https://travis-ci.org/openstax/action_interceptor.svg?branch=master)](https://travis-ci.org/openstax/action_interceptor)

Action Interceptor is a Rails engine that makes it easy to have controllers intercept
actions from other controllers, have users perform a task and then return them to where
they were before.

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

## Configuration

Run the following rake task to addAction Interceptor's
initializer to your application:

```sh
$ rake action_interceptor:install
```

## Usage
    
Add the following line to controllers that should
intercept actions from other controllers:

```rb
interceptor
```
    
Then declare the controllers and actions to be intercepted:

```rb
intercept ApplicationController, only: :index do
  # Block that returns:
  # The redirection path if the action is to be intercepted
  # Nil/false otherwise
end
```

When users complete the task, use the following method to
redirect them back to where they were before:

```rb
redirect_back
```

Alternatively, you can use `redirect_url` in views:

```erb
<%= link_to 'Back', redirect_url %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests for your feature
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

To run all existing tests for action_interceptor, simply execute the following from the main folder:

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
