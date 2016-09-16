Rails.application.routes.draw do
  scope defaults: { format: :json } do
    devise_for :users, only: []
  end

  namespace :v1, defaults: { format: "json" } do
    devise_scope :user do
      post "users/sign_in", to: "sessions#create"
    end

    resources :auth_phone_codes, only: %i(create)
    resources :activities, only: %i(create index)
    resources :providers, only: %i(index)
    resources :users_collection, only: %i(create)
    resources :users, only: %i(create update destroy) do
      get "account", on: :collection
    end
  end
end
