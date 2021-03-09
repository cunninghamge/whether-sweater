Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'weather#show'
      get 'background', to: 'background#show'
      post 'sessions', to: 'sessions#create'
      post 'road_trip', to: 'road_trip#create'
      resources :users, only: [:create]
    end
  end
end
