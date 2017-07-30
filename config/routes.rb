Rails.application.routes.draw do
  resources :movies

  get :search, controller: :main
  root to: "main#index"
end
