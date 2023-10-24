Rails.application.routes.draw do
  root to: "books#index"
  devise_for :users
  resources :books
  resources :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
