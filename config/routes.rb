Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users
  root to: 'searches#new'
  resources :scrapers
  resources :searches do
    collection do
      get "common", to: "searches#common"
      get "stats", to: "searches#stats"
      get "dashboard", to: "searches#dashboard"
    end
  end
  resources :jobs do
    collection do
      get "favourite", to: "jobs#favourite"
    end
    member do
      put "like" => "jobs#upvote"
      put "dislike" => "jobs#downvote"
    end
  end
  resources :admins
  resources :firms
  resources :websites

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
