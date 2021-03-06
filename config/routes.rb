require 'sidekiq/web'

Myflix::Application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'
  root to: 'pages#front'
  get 'failed_token', to: 'pages#failed_token'
  get 'home', to: 'videos#index'

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'register', to: 'users#new'
  resources :users, only: [:create, :show]

  resources :charges, only: [:new, :create]

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  resources :videos do
    collection do
      post :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :reviews, only: [:create]

  resources :categories, only: [:show]

  

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  get 'expired_token', to: 'reset_passwords#expired_token'
  resources :reset_passwords, only: [:show, :create]

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  # get 'invite_a_friend', to: 'invitations#new
  resources :invitations, only: [:new, :create]
  get 'ui(/:action)', controller: 'ui'

  get '*path', controller: 'catch_all', action: 'index'

end