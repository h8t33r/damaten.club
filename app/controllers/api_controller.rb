class ApiController < ApplicationController

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
end
