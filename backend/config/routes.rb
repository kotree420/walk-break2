Rails.application.routes.draw do
  root "walking_routes#home"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :profiles, only: [:index, :show, :edit, :update] do
    collection do
      get 'search'
      patch 'withdrawal'
    end
  end
  resources :walking_routes do
    collection do
      get 'search'
    end
    resource :bookmarks, only: [:create, :destroy]
  end

  namespace :api do
    namespace :v1 do
      namespace :user do
        post '/login', to: 'sessions#create'
      end
    end
  end
end
