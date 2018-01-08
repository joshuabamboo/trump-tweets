Rails.application.routes.draw do
  resources :tweets, only: :index
  get '/data', to: 'tweets#data', as: 'data', :defaults => { :format => 'csv' }

  root 'tweets#index'
end
