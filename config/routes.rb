Rails.application.routes.draw do
  # Authentication
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  # Customer-facing
  resources :tables, only: [ :index ]
  resources :reservations, only: [ :new, :create, :index, :destroy ]
  get "my_reservations", to: "reservations#index"

  # Admin
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :reservations, only: [ :index, :destroy ]
  end

  # Root
  root "tables#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
