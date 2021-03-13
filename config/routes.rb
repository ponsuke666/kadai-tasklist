Rails.application.routes.draw do
  root to: 'toppages#index'
  
  resources :tasks
end
