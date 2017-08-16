Rails.application.routes.draw do
  # Show Views
  get "/:name", to: "users#show", as: "user"
  get "/:name/*path", to: "explorer#open", as: "open"

  # User Control
  post "/users", to: "users#create", as: "users"
  patch "/users/:name", to: "users#update", as: "update_user"
  delete "/users/:name", to: "users#destroy", as: "destroy_user"

  # Session Control
  post "/sessions", to: "sessions#create", as: "sessions"
  delete "/sessions/:id", to: "sessions#destroy", as: "session"

  # Admin Control
  patch "/admin/users/:name", to: "users#admin_update_user"
  delete "/admin/users", to: "users#admin_destroy_users"

  # File Management
  post "/:name/*path/upload", to: "explorer#upload"
  post "/:name/*path/newfolder", to: "explorer#newfolder"
  delete "/:name/*path", to: "explorer#delete"
  patch "/:name/*path", to: "explorer#rename"

  root "users#index"
end
