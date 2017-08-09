Rails.application.routes.draw do
  # User Control
  post "/users", to: "users#create", as: "users"
  patch "/users/:name", to: "users#update", as: "update_user"
  delete "/users/:name", to: "users#destroy", as: "destroy_user"

  # Session Control
  post "/sessions", to: "sessions#create", as: "sessions"
  delete "/sessions/:id", to: "sessions#destroy", as: "session"

  # User Page
  get "/:name", to: "users#show", param: :name, as: "user"

  root "users#index"
end
