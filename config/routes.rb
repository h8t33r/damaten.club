Rails.application.routes.draw do
  devise_for :users
  
  resources :rules
  resources :games
  resources :players
  
  get 'welcome' => 'welcome#index'
  get 'ranking' => 'players#about_ranking'
  get 'ranks/:id' => 'players#rank_statistics', as: 'ranks'

  get 'api/about'
  get 'api/players'
  get 'api/games'
  get 'api/csv' => 'api#csv_import'

  get 'admin/players' => 'players#admin_players'
  get 'admin/users' => 'admin#show_devise_users'
  get 'admin/elo' => 'players#elo_rating'
  get 'admin/imports' => 'admin#imports'

  root 'welcome#index'
end
