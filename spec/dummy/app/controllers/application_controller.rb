class ApplicationController < ActionController::Base
  protect_from_forgery

  cattr_accessor :is_registered

  interceptor :registration, :my_interceptor
end
