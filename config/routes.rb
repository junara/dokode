# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  get '/search' => 'home#search'
  get '/events/:token' => 'events#show', as: 'event'
  post '/events/:token' => 'events#create'
  resources 'feed'
end
