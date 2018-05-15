# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all
  devise_scope :user do
    get    'users/sign_in',       to: 'users/sessions#new',         as: 'new_user_session'
    post   'users/sign_in',       to: 'users/sessions#create',      as: 'user_session'
    delete 'users/sign_out',      to: 'users/sessions#destroy',     as: 'destroy_user_session'
    get    'users/sign_up',       to: 'users/registrations#new',    as: 'new_user_registration'
    post   'users',               to: 'users/registrations#create', as: 'user_registration'
    get    '/users/confirmation', to: 'devise/confirmations#show',  as: 'user_confirmation'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

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
    resources :remit_request_results, only: %i[index]
  end
  get '/dashboard', to: 'dashboard#show'
  root to: 'pages#root'
end
