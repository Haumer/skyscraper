Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'searches#new'
  resources :searches, only: [ :show, :index, :new, :create ] do
    collection do
      get "common", to: "searches#common"
      get "stats", to: "searches#stats"
      get "dashboard", to: "searches#dashboard"
    end
  end
  resources :jobs, only: [ :show, :index ] do
    collection do
      get "favourite", to: "jobs#favourite"
    end
    member do
      put "like" => "jobs#upvote"
      put "dislike" => "jobs#downvote"
    end
  end
  resources :admins
  resources :firms, only: [ :show, :index ]
  resources :websites, only: [ :show, :index ]
  resources :search_histories, only: [ :index ]
end
