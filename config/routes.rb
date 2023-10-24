Rails.application.routes.draw do
  # get 'home/index'
  root to: "books#index"
  # get '/users/sign_out', 'devise/sessions#destroy'
  devise_for :users
  resources :books
  resources :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
