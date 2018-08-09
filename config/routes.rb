Rails.application.routes.draw do
  devise_for :users, 
    controllers: {registrations: "users/registrations"}

  resources :customers do
    resources :logins, only: [:index, :show]
  end
end
