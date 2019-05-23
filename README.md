# Action Interceptor

[![Gem Version](https://badge.fury.io/rb/action_interceptor.svg)](http://badge.fury.io/rb/action_interceptor)
[![Build Status](https://travis-ci.org/openstax/action_interceptor.svg?branch=master)](https://travis-ci.org/openstax/action_interceptor)
[![Code Climate](https://codeclimate.com/github/openstax/action_interceptor.png)](https://codeclimate.com/github/openstax/action_interceptor)

Action Interceptor is a Rails engine that makes it easy to store and
retrieve return url's across multiple requests and different controllers.

This can be used, for example, for registration, authentication,
signing terms of use, etc.

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
to your application's root url.

## Usage

Before your before_action or controller redirects the user to the
login/registration/terms of use page, call `store_url`
to store the current url.

In the login/registration/terms of use page, call `store_fallback`
to store the http referer, in case the user reached that page
through an unexpected path.

When the user is done with their task, call `redirect_back`
to send them back to where they were before.

All of those methods can also take an options hash,
where you can pass a `:key` argument.
If your site uses multiple different redirects, you can specify
a different `:key` for each in order to have them not overwrite each other.

Just by including the gem in your app, the following convenience methods
will also be added to all controllers as helper methods, so they will also
be available in views: `current_page?(url)`, `current_url` and `stored_url`.

  - `current_url` returns the current url.
  - `current_page?(url)` returns true iif the given url is the `current_url`.
  - `stored_url` returns the stored url.

The following convenience methods are also added to controllers:
`store_url`, `store_fallback`, `delete_stored_url` and `redirect_back`.
These methods have the following behavior:

  - `store_url` stores the current url
    (or specify the url using the `:url` option).
  - `store_fallback` stores the http referer only if no stored url
    is already present (or specify the fallback url using `:url` option).
  - `delete_stored_url` deletes the stored url.
  - `redirect_back` redirects the user to the stored url and deletes it.

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
