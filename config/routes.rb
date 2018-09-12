Rails.application.routes.draw do
  devise_for :users
  resources :rules
  resources :games
  resources :players
  
  get 'all' => 'welcome#index'

  get 'api/about'
  get 'api/players'
  get 'api/games'
  #get 'api/csv' => 'api#csv_import'

  get 'admin/players' => 'players#admin_players'

  root 'games#index'
  #root 'welcome#index'
end
