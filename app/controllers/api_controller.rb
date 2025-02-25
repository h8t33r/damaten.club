class ApiController < ApplicationController
  before_action :authenticate_user!, except: [:players, :games, :about]
  require 'csv'

  def about
    
  end
  
  def players
    players = Player.select(:id, :name)

    respond_to do |format|
      format.json {render json: players}
    end
  end

  def games
    games = Game.select(:id, :score, :created_at)

    respond_to do |format|
      format.json {render json: games}
    end
  end

  def csv_import

    game_data = Hash.new
    CSV.foreach("public/result_csv/RAW_all_games.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
      hashed_row = row.to_h

      game_data[:created_at] = hashed_row[:created_at].to_date

      game_data[:score] = {}
      game_data[:score][:east] = {}
      game_data[:score][:east][:player_id] = hashed_row[:player_east].to_s
      game_data[:score][:east][:player_score] = hashed_row[:player_east_score].to_s

      game_data[:score][:south] = {}
      game_data[:score][:south][:player_id] = hashed_row[:player_south].to_s
      game_data[:score][:south][:player_score] = hashed_row[:player_south_score].to_s

      game_data[:score][:west] = {}
      game_data[:score][:west][:player_id] = hashed_row[:player_west].to_s
      game_data[:score][:west][:player_score] = hashed_row[:player_west_score].to_s

      game_data[:score][:north] = {}
      game_data[:score][:north][:player_id] = hashed_row[:player_north].to_s
      game_data[:score][:north][:player_score] = hashed_row[:player_north_score].to_s

      game = Game.new
      game.created_at = game_data[:created_at]
      game.score = game_data[:score]
      game.save

    end

    render html: "all games/data serialized and saved"
  end

end
