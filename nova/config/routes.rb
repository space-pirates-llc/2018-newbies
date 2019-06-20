# frozen_string_literal: true

Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  namespace :api, defaults: { format: 'json' } do
    resource :user, only: %i[show update]
    resource :credit_card, only: %i[show create]
    resources :charges, only: %i[index create]
    resources :charge_histories, only: %i[index]
    resources :remit_requests, only: %i[index create] do
      member do
        post :accept
        post :reject
        post :cancel
      end
    end
    resources :remit_request_results, only: %i[index]
    resource :balance, only: %i[show]
  end
  get '/dashboard', to: 'dashboard#show'
  root to: 'pages#root'
end
