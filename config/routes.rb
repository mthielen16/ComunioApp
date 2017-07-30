Rails.application.routes.draw do
  resources :players

  get :search, controller: :main
  root to: "main#index"
end
