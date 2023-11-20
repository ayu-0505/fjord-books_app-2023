Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :reports, only:[:index]
  resources :users, only: %i(index show) do
    resources :reports, except:[:index]
  end
end
