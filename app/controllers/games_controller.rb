class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  require 'csv'

  def csv_import

    player = Player.all

    game_data = Hash.new
    CSV.foreach("public/2018_games.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
      hashed_row = row.to_h

      # ["updated_at", "2018-08-11 07:52:38.977253"]
      game_data[:created_at] = hashed_row[:created_at].to_date

      game_data[:score] = {}
      game_data[:score][:east] = {}
      game_data[:score][:east][:player_id] = 1#hashed_row[:player_east]
      game_data[:score][:east][:score] = hashed_row[:player_east_score]

      game_data[:score][:sauth] = {}
      game_data[:score][:sauth][:player_id] = 2#hashed_row[:player_south]
      game_data[:score][:sauth][:score] = hashed_row[:player_south_score]

      game_data[:score][:west] = {}
      game_data[:score][:west][:player_id] = 3#hashed_row[:player_west]
      game_data[:score][:west][:score] = hashed_row[:player_west_score]

      game_data[:score][:north] = {}
      game_data[:score][:north][:player_id] = 4#hashed_row[:player_north]
      game_data[:score][:north][:score] = hashed_row[:player_north_score]

    end
    #g = game.new
    #g.save
    render json: game_data
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
