Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create]
      resources :tokens, only: %i[create]
      resources :books, only: %i[update create destroy]
    end
  end
end
