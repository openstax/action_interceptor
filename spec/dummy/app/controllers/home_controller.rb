class HomeController < ActionController::Base
  skip_interceptor :registration, only: :index
  
  def index
  end
  
  def api
  end
end

