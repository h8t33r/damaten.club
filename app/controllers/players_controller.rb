class PlayersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :about_ranking]
  before_action :set_player, only: [:show, :edit, :update, :destroy, :rank_statistics]

  def index
    @players = Player.order(rank: :desc)
    @games = Game.all
  end

  def show
    @players = Player.select(:id, :name)
    @games = Game.find_by_sql ["SELECT id, score, created_at
      FROM games
      WHERE score #>> '{east, player_id}' = '?'
      OR score #>> '{south, player_id}' = '?'
      OR score #>> '{west, player_id}' = '?'
      OR score #>> '{north, player_id}' = '?'
      ORDER BY created_at DESC;
      ", @player.id, @player.id, @player.id, @player.id]
  end

  def admin_players
    @players = Player.order(created_at: :asc)
  end

  def about_ranking
    
  end

  def rank_statistics
    @ranks = Rank.where(:player_id => params[:id])
  end

  def new
    @player = Player.new
  end

  def edit
  end

  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Игрок создан.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def elo_rating

    Player.update_all("rank = 1500")
    
    games_query = "SELECT id, created_at,
      (SELECT name FROM players WHERE CAST (id AS TEXT) = games.score #>> '{east, player_id}') AS east_name,
      (SELECT rank FROM players WHERE CAST (id AS TEXT) = games.score #>> '{east, player_id}') AS east_rating,
      CAST ((games.score #>> '{east, player_id}') AS integer) AS east_id,
      CAST ((games.score #>> '{east, player_score}') AS integer) AS east_score,
      (SELECT COUNT(*)
       FROM games as c_games
       WHERE (c_games.score #>> '{east, player_id}' = games.score #>> '{east, player_id}'
       OR c_games.score #>> '{south, player_id}' = games.score #>> '{east, player_id}'
       OR c_games.score #>> '{west, player_id}' = games.score #>> '{east, player_id}'
       OR c_games.score #>> '{north, player_id}' = games.score #>> '{east, player_id}')
     AND c_games.created_at <= games.created_at
      ) AS east_game_count,
    
      (SELECT name FROM players WHERE CAST (id AS TEXT) = games.score #>> '{south, player_id}') AS south_name,
      (SELECT rank FROM players WHERE CAST (id AS TEXT) = games.score #>> '{south, player_id}') AS south_rating,
      CAST ((games.score #>> '{south, player_id}') AS integer) AS south_id,
      CAST ((games.score #>> '{south, player_score}') AS integer) AS south_score,
      (SELECT COUNT(*)
       FROM games as c_games
       WHERE (c_games.score #>> '{east, player_id}' = games.score #>> '{south, player_id}'
       OR c_games.score #>> '{south, player_id}' = games.score #>> '{south, player_id}'
       OR c_games.score #>> '{west, player_id}' = games.score #>> '{south, player_id}'
       OR c_games.score #>> '{north, player_id}' = games.score #>> '{south, player_id}')
     AND c_games.created_at <= games.created_at
      ) AS south_game_count,
    
      (SELECT name FROM players WHERE CAST (id AS TEXT) = games.score #>> '{west, player_id}') AS west_name,
      (SELECT rank FROM players WHERE CAST (id AS TEXT) = games.score #>> '{west, player_id}') AS west_rating,
      CAST ((games.score #>> '{west, player_id}') AS integer) AS west_id,
      CAST ((games.score #>> '{west, player_score}') AS integer) AS west_score,
      (SELECT COUNT(*)
       FROM games as c_games
       WHERE (c_games.score #>> '{east, player_id}' = games.score #>> '{west, player_id}'
       OR c_games.score #>> '{south, player_id}' = games.score #>> '{west, player_id}'
       OR c_games.score #>> '{west, player_id}' = games.score #>> '{west, player_id}'
       OR c_games.score #>> '{north, player_id}' = games.score #>> '{west, player_id}')
     AND c_games.created_at <= games.created_at
      ) AS west_game_count,
    
      (SELECT name FROM players WHERE CAST (id AS TEXT) = games.score #>> '{north, player_id}') AS north_name,
      (SELECT rank FROM players WHERE CAST (id AS TEXT) = games.score #>> '{north, player_id}') AS north_rating,
      CAST ((games.score #>> '{north, player_id}') AS integer) AS north_id,
      CAST ((games.score #>> '{north, player_score}') AS integer) AS north_score,
      (SELECT COUNT(*)
       FROM games as c_games
       WHERE (c_games.score #>> '{east, player_id}' = games.score #>> '{north, player_id}'
       OR c_games.score #>> '{south, player_id}' = games.score #>> '{north, player_id}'
       OR c_games.score #>> '{west, player_id}' = games.score #>> '{north, player_id}'
       OR c_games.score #>> '{north, player_id}' = games.score #>> '{north, player_id}')
     AND c_games.created_at <= games.created_at
      ) AS north_game_count
    FROM games
    ORDER BY id ASC
    LIMIT 1 OFFSET ?;"

    start_offset = 0
    games_count = Game.count
    @result = []

    while start_offset <= games_count
      games = Game.find_by_sql [games_query, start_offset]
      games.each do |game|
        @result << rating_change(game)
      end
      start_offset +=1
    end
  end

  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Данные игрока благополучно изменены.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Игрок удален из базы, это ОЧЕНЬ плохо.' }
      format.json { head :no_content }
    end
  end

  private

  def rating_change(game)
    # ratings
    east_rating  = game.east_rating
    south_rating = game.south_rating
    west_rating  = game.west_rating
    north_rating = game.north_rating

    # temp games count
    east_c  = game.east_game_count
    south_c = game.south_game_count
    west_c  = game.west_game_count
    north_c = game.north_game_count

    # add scores in array
    score_array = [
      game.east_score,
      game.south_score,
      game.west_score,
      game.north_score
    ]
    # выяисляем среднне арифметическое рейтинга играков за столом
    avg_table_rait = (east_rating + south_rating + west_rating + north_rating ) / 4

    # хэш для возвращения во вьюху
    rating_hash = Hash.new

    # для востока
    adjustment = adjustment_calc(east_c)
    place_base = place_base_calc(score_array, game.east_score)
    new_east_rating = adjustment * (place_base + (avg_table_rait - east_rating) / 40)
    rating_hash['east'] = (east_rating + new_east_rating).round 0
    rating_hash['east_name'] = game.east_name

    # для юга
    adjustment = adjustment_calc(south_c)
    place_base = place_base_calc(score_array, game.south_score)
    new_south_rating = adjustment * (place_base + (avg_table_rait - south_rating) / 40)
    rating_hash['south'] = (south_rating + new_south_rating).round 0
    rating_hash['south_name'] = game.south_name

    # для запада
    adjustment = adjustment_calc(west_c)
    place_base = place_base_calc(score_array, game.west_score)
    new_west_rating = adjustment * (place_base + (avg_table_rait - west_rating) / 40)
    rating_hash['west'] = (west_rating + new_west_rating).round 0
    rating_hash['west_name'] = game.west_name

    # для севера
    adjustment = adjustment_calc(north_c)
    place_base = place_base_calc(score_array, game.north_score)
    new_north_rating = adjustment * (place_base + (avg_table_rait - north_rating) / 40)
    rating_hash['north'] = (north_rating + new_north_rating).round 0
    rating_hash['north_name'] = game.north_name

    #update
    t_east_player = Player.find(game.east_id)
    t_east_player.rank = rating_hash['east']
    t_east_player.save

    r = Rank.create(player_id: game.east_id, rating_change: rating_hash['east'], created_at: game.created_at)

    t_south_player = Player.find(game.south_id)
    t_south_player.rank = rating_hash['south']
    t_south_player.save

    r = Rank.create(player_id: game.south_id, rating_change: rating_hash['south'], created_at: game.created_at)

    t_west_player = Player.find(game.west_id)
    t_west_player.rank = rating_hash['west']
    t_west_player.save

    r = Rank.create(player_id: game.west_id, rating_change: rating_hash['west'], created_at: game.created_at)

    t_north_player = Player.find(game.north_id)
    t_north_player.rank = rating_hash['north']
    t_north_player.save

    r = Rank.create(player_id: game.north_id, rating_change: rating_hash['north'], created_at: game.created_at)

    rating_hash['created_at'] = game.created_at.strftime("%Y.%m.%d")
    rating_hash['game_id'] = game.id

    return rating_hash
  end

  def adjustment_calc(wind)
    case wind
    when 0 .. 399
      adjustment = 1 - (wind * 0.002)
    else
      adjustment = 1 - 0.2 
    end

    return adjustment
  end

  def place_base_calc(a_score, wind)
    first_place_base   = 30
    second_place_base  = 10
    third_place_base   = -10
    fourth_place_base  = -30

    if wind == a_score.sort[3] then
      base_points = first_place_base
    elsif wind == a_score.sort[2]
      base_points = second_place_base
    elsif wind == a_score.sort[1]
      base_points = third_place_base
    elsif wind == a_score.sort[0]
      base_points = fourth_place_base
    end

    return base_points
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :nickname, :activated, :email)
    end
end
