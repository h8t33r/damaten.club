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
    @ranks = Rank.where(:player_id => params[:id]).order(:created_at)
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
    Rank.delete_all
    
    games_query = ["SELECT created_at,
      (score #>> '{east, player_id}')::bigint AS east_id,
      (score #>> '{east, player_score}')::integer AS east_score,
      (score #>> '{south, player_id}')::bigint AS south_id,
      (score #>> '{south, player_score}')::integer AS south_score,
      (score #>> '{west, player_id}')::bigint AS west_id,
      (score #>> '{west, player_score}')::integer AS west_score,
      (score #>> '{north, player_id}')::bigint AS north_id,
      (score #>> '{north, player_score}')::integer AS north_score
    FROM games
    ORDER BY id ASC;"]

    @result = Array.new

    games = Game.find_by_sql(games_query)

    games.each do |game|
      players_ranks = Hash.new

      players = Player.select(:id, :name, :rank, :games_count)

      players_ranks['east_rank'] = players.find_by(:id => game.east_id).rank
      players_ranks['east_games_count'] = players.find_by(:id => game.east_id).games_count

      players_ranks['south_rank'] = players.find_by(:id => game.south_id).rank
      players_ranks['south_games_count'] = players.find_by(:id => game.south_id).games_count

      players_ranks['west_rank'] = players.find_by(:id => game.west_id).rank
      players_ranks['west_games_count'] = players.find_by(:id => game.west_id).games_count

      players_ranks['north_rank'] = players.find_by(:id => game.north_id).rank
      players_ranks['north_games_count'] = players.find_by(:id => game.north_id).games_count

      f = rating_change(game, players_ranks)

      players.update([game.east_id, game.south_id, game.west_id, game.north_id],
        [
          {rank: f['east'], games_count: f['east_games_count']},
          {rank: f['south'], games_count: f['south_games_count']},
          {rank: f['west'], games_count: f['west_games_count']},
          {rank: f['north'], games_count: f['north_games_count']}
        ])

      Rank.create(player_id: game.east_id, rating_change: f['east'], created_at: game.created_at)
      Rank.create(player_id: game.south_id, rating_change: f['south'], created_at: game.created_at)
      Rank.create(player_id: game.west_id, rating_change: f['west'], created_at: game.created_at)
      Rank.create(player_id: game.north_id, rating_change: f['north'], created_at: game.created_at)

      @result << f

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

  def rating_change(game, player)
    # ratings
    east_rating  = player['east_rank']
    south_rating = player['south_rank']
    west_rating  = player['west_rank']
    north_rating = player['north_rank']

    # games count
    east_c  = player['east_games_count']
    south_c = player['south_games_count']
    west_c  = player['west_games_count']
    north_c = player['north_games_count']

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
    rating_hash['east_games_count'] = east_c + 1

    # для юга
    adjustment = adjustment_calc(south_c)
    place_base = place_base_calc(score_array, game.south_score)
    new_south_rating = adjustment * (place_base + (avg_table_rait - south_rating) / 40)
    rating_hash['south'] = (south_rating + new_south_rating).round 0
    rating_hash['south_games_count'] =south_c + 1


    # для запада
    adjustment = adjustment_calc(west_c)
    place_base = place_base_calc(score_array, game.west_score)
    new_west_rating = adjustment * (place_base + (avg_table_rait - west_rating) / 40)
    rating_hash['west'] = (west_rating + new_west_rating).round 0
    rating_hash['west_games_count'] = west_c + 1

    # для севера
    adjustment = adjustment_calc(north_c)
    place_base = place_base_calc(score_array, game.north_score)
    new_north_rating = adjustment * (place_base + (avg_table_rait - north_rating) / 40)
    rating_hash['north'] = (north_rating + new_north_rating).round 0
    rating_hash['north_games_count'] = north_c + 1

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
