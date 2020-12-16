Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      scope :revenue do
        get "/", to: 'revenue#revenue'
      end
      namespace :merchants do
        get '/find_all', to: 'search#show'
      end
      resources :merchants do
        get "/items", to: 'merchants/items#index'
      end
      resources :items, only: [:index] do
        get '/merchants', to: 'items/merchants#index'
      end
    end
  end
end
