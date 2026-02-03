Rails.application.routes.draw do
  get "signup" => "users#new", as: :users_new
  post "signup" => "users#create", as: :users_create
  delete "unregister/:id" => "users#destroy", as: :users_destroy

  get "login" => "sessions#new", as: :sessions_new
  post "login" => "sessions#create", as: :sessions_create
  delete "logout" => "sessions#destroy", as: :sessions_destroy

  get "users" => "users#index", as: :users_index
  get "users/:id" => "users#show", as: :users_show

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
