Rails.application.routes.draw do
  root 'application#index'
  
  resources :repositories, only: [:index]
end
