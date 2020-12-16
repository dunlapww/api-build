Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', to: 'search#show'
      end
      resources :merchants do
        get "/items", to: 'merchants#merchant_items'
      end
      resources :items, only: [:index] do
        get '/merchants', to: 'items#item_merchant'
      end
    end
  end
end
