Rails.application.routes.draw do
  resources :tweets, only: :index
  get '/data', to: 'tweets#data', as: 'data', :defaults => { :format => 'json' }
  get '/circle', to: 'tweets#circle', as: 'circle', :defaults => { :format => 'json' }
  get '/year-in-review', to: 'tweets#year', as: 'year'

  root 'tweets#index'
end
