Rails.application.routes.draw do
  resources :games
  resources :players
  
  get 'welcome' => 'welcome#index'

  get 'api/about'
  get 'api/players'
  get 'api/games'
  #get 'api/csv' => 'api#csv_import'

  root 'games#index'
  #root 'welcome#index'
end
