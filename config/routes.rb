# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/profile'
  # devise_for :users, controllers: {
  #   session: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
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
  get 'userinformation', to: 'home#userinformation'

  # stipe
  # stripe listen --forward-to localhost:3000/stripe/webhook
  post 'stripe/webhooks', to: 'stripe/webhooks#create'
  get 'pricing', to: 'stripe/checkout#pricing'
  post 'stripe/checkout', to: 'stripe/checkout#checkout'
  get 'stripe/checkout/success', to: 'stripe/checkout#success'
  get 'stripe/checkout/cancel', to: 'stripe/checkout#pricing'
  post 'stripe/billing_portal', to: 'stripe/billing_portal#create'

  # facebook login

  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
