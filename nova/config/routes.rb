# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resource :user, only: %i[show update]
    resource :credit_card, only: %i[show create]
    resources :charges, only: %i[index create]
    resources :remit_requests, only: %i[index create] do
      member do
        post :accept
        post :reject
        post :cancel
      end
    end
  end

  get '/dashboard', to: 'dashboard#show'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  root to: 'pages#root'

  resources :users
  resources :account_activations, only:[:edit]

end
