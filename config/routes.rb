Rails.application.routes.draw do
  scope defaults: { format: :json } do
    devise_for :users, only: []
  end

  namespace :v1, defaults: { format: "json" } do
    devise_scope :user do
      post "users/sign_in", to: "sessions#create"
    end

    namespace :zendesk do
      resources :users, only: %i(show update) do
        post :fetch, on: :collection
      end

      resources :tickets, only: :create
      resources :notification_subscribers, only: %i(create index destroy)

      resources :organizations, only: %i(update) do
        post :fetch, on: :collection
      end
    end

    resources :auth_phone_codes, only: %i(create) do
      post "check", on: :member
    end
    resources :activities, only: %i(create index)
    resources :providers, only: %i(index)
    resources :users_collection, only: %i(create)
    resources :fitness_tokens, only: %i(create destroy)

    resources :users, only: %i(create update destroy) do
      get "account", on: :collection
    end

    resources :notifications, only: %i(create destroy)
    resource :registration_status, only: %i(create)
    resources :subscriptions, only: %i(create) do
      patch "expire", on: :collection
    end
  end

  get "login", to: "android_verification#create", as: "android_verification"
end
