class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  require 'csv'

  def csv_import

    game_data = Hash.new
    CSV.foreach("public/RAW_all_games.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
      hashed_row = row.to_h

      game_data[:created_at] = hashed_row[:created_at].to_date

      game_data[:score] = {}
      game_data[:score][:east] = {}
      game_data[:score][:east][:player_id] = hashed_row[:player_east]
      game_data[:score][:east][:player_score] = hashed_row[:player_east_score]

      game_data[:score][:south] = {}
      game_data[:score][:south][:player_id] = hashed_row[:player_south]
      game_data[:score][:south][:player_score] = hashed_row[:player_south_score]

      game_data[:score][:west] = {}
      game_data[:score][:west][:player_id] = hashed_row[:player_west]
      game_data[:score][:west][:player_score] = hashed_row[:player_west_score]

      game_data[:score][:north] = {}
      game_data[:score][:north][:player_id] = hashed_row[:player_north]
      game_data[:score][:north][:player_score] = hashed_row[:player_north_score]

      game = Game.new
      game.created_at = game_data[:created_at]
      game.score = game_data[:score]
      game.save

    end

    render html: "all games/data serialized and saved"
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.order(created_at: :desc)
    @players = Player.select(:name)
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  def new
    @players = Player.select(:id, :name).where(activated: true)
    @game = Game.new
  end

  def edit
    @players = Player.select(:id, :name).where(activated: true)
  end

  # POST /games
  # POST /games.json
  def create
    #render html: game_params
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:score => {})
    end
end
