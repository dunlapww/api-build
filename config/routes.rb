Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :items, only: [:index] do
        get '/merchant', to: 'items#item_merchant'
      end
      get 'merchants/search', to: 'merchants#search'
      resources :merchants do
        get "/items", to: 'merchants#merchant_items'
      end
    end
  end
end
