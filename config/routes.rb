Rails.application.routes.draw do
  resources :tweets, only: :index
  root 'tweets#index'
end
