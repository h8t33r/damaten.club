Rails.application.routes.draw do
  devise_for :users
  
  resources :rules
  resources :games
  resources :players
  
  get 'welcome' => 'welcome#index'

  get 'api/about'
  get 'api/players'
  get 'api/games'
  get 'api/csv' => 'api#csv_import'

  get 'admin/players' => 'players#admin_players'
  get 'admin/users' => 'admin#show_devise_users'
  get 'admin/:id' => 'admin#link_user_to_player'

  root 'welcome#index'
end
