Rails.application.routes.draw do
  resources :games
  resources :players
  
  get 'welcome/index'
  get 'csv' => 'games#csv_import'

  root 'games#index'
  #root 'welcome#index'
end
