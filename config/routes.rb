Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'weather#show'
      get 'background', to: 'background#show'
      post 'sessions', to: 'sessions#create'
      resources :users, only: [:create]
      get 'munchies', to: 'munchies#show'
    end
  end
end
