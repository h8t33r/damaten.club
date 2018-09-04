class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.order(activated: :desc)
    @games = Game.all
  end

  # GET /players/1
  # GET /players/1.json GOVNOCODE
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

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
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

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
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

  # DELETE /players/1
  # DELETE /players/1.json
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
      params.require(:player).permit(:name, :nickname, :activated)
    end
end
