Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', to: 'search#show'
      end
      resources :merchants do
        get "/items", to: 'merchant_items#index'
      end
      resources :items, only: [:index] do
        get '/merchants', to: 'items_merchant#index'
      end
    end
  end
end
