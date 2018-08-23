Rails.application.routes.draw do
  resources :games
  resources :players
  
  get 'welcome' => 'welcome#index'
  get 'csv_import' => 'games#csv_import'

  root 'games#index'
  #root 'welcome#index'
end
