Rails.application.routes.draw do
  # User Control
  post "/users", to: "users#create", as: "users"
  patch "/users/:name", to: "users#update", as: "update_user"
  delete "/users/:name", to: "users#destroy", as: "destroy_user"

  # Session Control
  post "/sessions", to: "sessions#create", as: "sessions"
  delete "/sessions/:id", to: "sessions#destroy", as: "session"

  # User Page (Storage)
  get "/:name", to: "explorer#show", as: "user"
  get "/:name/*path", to: "explorer#open", as: "open"
  
  # File Management
  post "/:name/*path", to: "explorer#upload", as: "upload"


  root "users#index"
end
