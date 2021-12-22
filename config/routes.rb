Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # Slangs routes
      resources :slangs, only: %i[index create destroy]
      post 'up_vote/:slang_id', to: 'votes#like'
      post 'down_vote/:slang_id', to: 'votes#dislike'

      # Search routes
      get 'search', to: 'search#index'

      # Register Route
      post 'register', to: 'registrations#create'

      # Authentication routes
      post 'authenticate', to: 'authentication#create'

      # User routes
      get 'user/:username', to: 'user#index', username: %r{[^/]+}
      get 'profile/settings', to: 'user#settings'
      patch 'profile/settings', to: 'user#settings_update'

      # Admin routes
      get 'admin', to: 'admin#index'
      patch 'admin/slang/:slang_id', to: 'admin#approve'
      delete 'admin/slang/:slang_id', to: 'admin#destroy'
    end
  end
end
