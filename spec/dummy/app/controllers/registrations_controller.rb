class RegistrationsController < ActionController::Base
  acts_as_interceptor

  skip_interceptor :registration

  def new
    redirect_to registration_register_path
  end

  def register
    redirect_back notice: 'Registration successful!'
  end
end

