Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'weather#show'
      get 'background', to: 'background#show'
      resources :users, only: [:create]
    end
  end
end
