Rails.application.routes.draw do
  root "grams#index"
  devise_for :users
  resources :grams, only: [:new, :create, :show, :edit, :update, :destroy]

end
