Rails.application.routes.draw do
  authenticated do
    root 'rooms#index', as: :authenticated_root
  end

  devise_scope :user do
    root "users/sessions#new"
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks'
  }

  resources :rooms do
    resources :messages
  end

  get 'home' => 'home#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
