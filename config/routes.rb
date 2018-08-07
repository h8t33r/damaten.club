Rails.application.routes.draw do
  resources :games
  resources :players
  
  get 'welcome/index'

  root 'welcome#index'
end
