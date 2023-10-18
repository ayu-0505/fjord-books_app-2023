Rails.application.routes.draw do
  # get 'home/index'
  devise_for :users
  resources :books

  root to: "home#index"
end
