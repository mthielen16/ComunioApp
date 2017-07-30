Rails.application.routes.draw do
  resources :movies
  resources :players

  get :search, controller: :main
  root to: "main#index"
end
