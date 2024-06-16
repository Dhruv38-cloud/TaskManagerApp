require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    member do
      patch :change_state
    end
  end

  root to: 'tasks#index'
  mount Sidekiq::Web => '/sidekiq'
  
end
