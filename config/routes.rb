Rails.application.routes.draw do
  get "games/new"
  devise_for :players

  # Routes pour les profils de joueurs
  resources :players, only: [:show]

  # Autres routes
  resources :games
  patch "games/:id/play", to: "games#play"
  patch "games/:id/pass", to: "games#pass"
  patch "games/:id/give_up", to: "games#give_up"
  get "games/:id/result", to: "games#result"

  root to: "pages#home"

  get '/how_to_play', to: 'static_pages#how_to_play', as: :how_to_play
  get '/profile', to: 'players#profile', as: :profile


  resources :availabilities, only: [:index, :show, :create, :destroy] do
    collection do
      post :match
    end
  end

  resources :games do
    member do
      post :play_turn
    end
  end

  # Routes pour la santé et les fichiers PWA
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
