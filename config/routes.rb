Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :items, only: [:index]
      resources :merchants, only: [:index, :show, :create, :destroy]
      patch "/merchants/:id", to: 'merchants#update'
    end
  end
end
