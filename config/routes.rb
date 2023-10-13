Rails.application.routes.draw do
  resources :books
  #追記(あとで作る)
  root to: "home#index"
end
