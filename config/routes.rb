Rails.application.routes.draw do
  devise_for :users, 
    controllers: {registrations: "users/registrations"}

  resources :customers do
    resources :logins, shallow: true
  end
  resources :accounts
  resources :transactions

  root "customers#index" 
end
