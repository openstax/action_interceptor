$:.push File.expand_path('../lib', __FILE__)

require 'action_interceptor/version'

Gem::Specification.new do |s|
  s.name        = 'action_interceptor'
  s.version     = ActionInterceptor::VERSION
  s.authors     = ['Dante Soares']
  s.email       = ['dms3@rice.edu']
  s.homepage    = 'http://github.com/openstax/action_interceptor'
  s.license     = 'MIT'
  s.summary     = "Handles storage of return url's across multiple requests"
  s.description = "Action Interceptor provides methods to store return url's across multiple requests. Useful during authentication, registration, signing terms of use, etc."

  s.files = Dir["{config,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end

