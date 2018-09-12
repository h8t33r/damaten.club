class PlayersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = Player.order(activated: :desc)
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

  def elo_ranking
    
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
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :nickname, :activated, :email)
    end
end
