class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @year = params[:year]
    @games = Game.order(created_at: :desc).where("EXTRACT(year FROM created_at) = ?", @year)
    @players = Player.select(:name)
  end

  def show
    @players = Player.select(:name)
  end

  def new
    @players = Player.select(:id, :name).where(activated: true)
    @game = Game.new
  end

  def edit
    @players = Player.select(:id, :name).where(activated: true)
  end

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
