Rails.application.routes.draw do
  resources :players
  get "gesamtmarktwert", to: "gesamtmarktwert#index"

  get :search, controller: :main
  root to: "main#index"
end
