Rails.application.routes.draw do
  resources :tweets, only: :index
  get '/data', to: 'tweets#data', as: 'data', :defaults => { :format => 'json' }

  root 'tweets#index'
end
