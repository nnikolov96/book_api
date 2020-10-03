Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'books/search' => 'books#index'
      resources :users, only: %i[create]
      resources :tokens, only: %i[create]
      resources :books do
        resources :reviews
      end
    end
  end
end
