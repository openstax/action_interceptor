$:.push File.expand_path('../lib', __FILE__)

require 'action_interceptor/version'

Gem::Specification.new do |s|
  s.name        = 'action_interceptor'
  s.version     = ActionInterceptor::VERSION
  s.authors     = ['Dante Soares']
  s.email       = ['dms3@rice.edu']
  s.homepage    = 'http://github.com/openstax/action_interceptor'
  s.license     = 'MIT'
  s.summary     = 'Handles redirection to and from `interceptor` controllers.'
  s.description = 'Facilitates redirection to and from controllers that require users to perform some task, then redirect them back to where they were.'

  s.files = Dir['lib/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 3.1'
  s.add_dependency 'public_suffix', '>= 0.9.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end

