# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resource :user, only: %i[show update]
    resources :user_emails, only: %i[create]
    resource :credit_card, only: %i[show create destroy]
    resources :charges, only: %i[index create]
    resources :remit_requests, only: %i[index create] do
      member do
        post :accept
        post :reject
        post :cancel
      end
    end
  end

  resources :password_resets, only: %i[new create edit update]

  get '/dashboard', to: 'dashboard#show'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  root to: 'pages#root'
end
