# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new' # NEW registration page
  post '/signup', to: 'users#create' # NEW registration post / resolving discrepancy
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
