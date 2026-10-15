Rails.application.routes.draw do
  
  post "/signup", to: "registrations#create"
  post "/login", to: "sessions#create"

  
  resources :employees, only: [:index, :show, :create, :update, :destroy]
  resources :attendances, only: [:index, :show, :create, :update, :destroy]
  resources :leave_requests, only: [:index, :show, :create, :update, :destroy]
end