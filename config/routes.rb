require 'api_version_constraint'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :registrations, only: %i[create]
      resources :sessions, only: %i[create]
      resources :users, only: %i[index]
      resources :apps do
        resources :rooms, only: %i[index create]
      end
      resources :rooms, only: %i[index show update destroy] do
        member do
          get "/participants", to: "rooms#participants"
          post "/participants", to: "rooms#add_participant"
          delete "/participants/:room_participant", to: "rooms#remove_participant"
          put "/participants/:room_participant", to: "rooms#change_role"
        end
      end
    end
  end
end
