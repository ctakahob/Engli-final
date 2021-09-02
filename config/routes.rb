Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end
  root 'phrases#index'
  resources :phrases do
    member do
      post :like
    end
    resources :examples, only: %i[create destroy] do
      member do
        post :vote
      end
    end
  end
  resources :notifications, only: %i[index destroy] do
    collection do
      put :read_all
    end
  end
  resources :users
  match '*path' => redirect('/'), via: %i[get post]
end
