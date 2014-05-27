Rails.application.routes.draw do
  resource :registration, :only => [:new] do
    get :register
  end

  get 'home/api'

  root to: 'home#index'
end
