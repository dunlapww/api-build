Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      scope :revenue do
        get "/", to: 'revenue#revenue'
      end
      namespace :merchants do
        get '/find_all', to: 'search#find_all'
        get '/find', to: 'search#find_first'
        get '/most_revenue', to: 'search#most_revenue'
        get '/most_items', to: 'search#most_items'
      end
      resources :merchants do
        get "/items", to: 'merchants/items#index'
        get "/revenue", to: 'merchants#revenue'
      end
      namespace :items do
        get '/find_all', to: 'search#find_all'
        get '/find', to: 'search#find_first'
      end
      resources :items do
        get '/merchants', to: 'items/merchants#index'
      end
    end
  end
end
