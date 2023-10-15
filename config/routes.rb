Rails.application.routes.draw do
  devise_for :users
  resources :books
  #追記(あとで作る)
  root to: "home#index"
end
