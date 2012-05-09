Rails.application.routes.draw do
  resources :meta_types
  resources :meta_type_properties
  resources :things
  root to: 'dashboard#index'
end
