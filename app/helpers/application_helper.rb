module ApplicationHelper

  def get_player_name(wind, game, players)
    score = [
      game.score["east"]["player_score"],
      game.score["south"]["player_score"],
      game.score["west"]["player_score"],
      game.score["north"]["player_score"]
    ]

    if (score.max == game.score["#{wind}"]["player_score"]) then
      "👑 " + players.find(game.score["#{wind}"]["player_id"]).name
    else
      players.find(game.score["#{wind}"]["player_id"]).name
    end
  end

  def score_sum(game)
        game.score["east"]["player_score"].to_i +
        game.score["south"]["player_score"].to_i +
        game.score["west"]["player_score"].to_i +
        game.score["north"]["player_score"].to_i
  end

end
