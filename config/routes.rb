# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/profile'
  devise_for :users, controllers: {
    session: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/u/:id', to: 'users#profile', as: 'user'
  resources :posts do
    resources :comments
  end
  # get 'home' to: 'pages#home'
  get 'about', to: 'pages#about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # delete '/posts/:id', to: 'posts#destroy', as: 'post  '
  # Defines the root path route ("/")
  root 'pages#home'

  resources :posts do
    member do
      patch 'upvote'
      patch 'downvote'
    end
  end

  get '/posts/:id/upvote', to: 'posts#upvote'
  get 'post/:id/downvote', to: 'posts#downvote'

  put 'posts/:id/like', to: 'posts#like', as: 'like_post'

  get 'mypricing', to: 'home#mypricing'


end
