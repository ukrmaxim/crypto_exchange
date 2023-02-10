Rails.application.routes.draw do
  root 'static_pages#index'
  get 'update_rate', action: :update_rate, controller: 'static_pages'
  get 'check_balance', action: :check_balance, controller: 'wallets'

  resources :wallets, only: %i[index create update destroy]
  resources :settings, only: %i[index create update destroy]
  resources :transactions, only: %i[index new create]
end
