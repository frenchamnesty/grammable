Rails.application.routes.draw do
  root "grams#index"
  devise_for :users
  resources :grams do
    resources :comments, only: :create
  end
end
