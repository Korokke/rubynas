Rails.application.routes.draw do

  # User Control
  post "/users", to: "users#create"
  patch "/users/:name", to: "users#update"
  delete "/users/:name", to: "users#destroy"

  # Session Control
  post "/sessions", to: "sessions#create"
  delete "/sessions/:id", to: "sessions#destroy", as: 'session'

  # User Page
  get "/:name", to: "users#show", as: 'user'

  root "users#index"
end
