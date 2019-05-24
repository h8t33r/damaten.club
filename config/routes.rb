Rails.application.routes.draw do
  devise_for :users

  resources :games
  get 'games/year/:year' => 'games#index', as: 'games/year'

  resources :players

  get 'welcome' => 'welcome#index'
  get 'yaku' => 'welcome#yaku'
  get 'rulebook' => 'welcome#rulebook'
  get 'events' => 'welcome#events'


  get 'ranking' => 'players#about_ranking'
  get 'ranks/:id' => 'players#rank_statistics', as: 'ranks'

  get 'api/about'
  get 'api/players'
  get 'api/games'
  get 'api/csv' => 'api#csv_import'

  scope '/admin' do
    resources :rules

    get 'players' => 'players#admin_players'
    get 'users' => 'admin#show_devise_users'
    get 'imports' => 'admin#imports'
    get 'test' => 'players#test'
    get 'elo' => 'players#elo_rating'
  end

  root 'welcome#index'
end
