module PlayersHelper

  def results_counter(games, p_id, place)

    result_array = []

    games.each do |game|

      score = [
        game.score["east"]["player_score"],
        game.score["south"]["player_score"],
        game.score["west"]["player_score"],
        game.score["north"]["player_score"]
      ]

      if p_id == game.score["east"]["player_id"].to_i &&
      game.score["east"]["player_score"].to_i == score.sort[place].to_i &&
      game.score["east"]["player_score"].to_i != score.sort[place+1].to_i then

        result_array << game.score["east"]["player_score"].to_i

      elsif p_id == game.score["south"]["player_id"].to_i &&
      game.score["south"]["player_score"].to_i == score.sort[place].to_i &&
      game.score["south"]["player_score"].to_i != score.sort[place+1].to_i 

        result_array << game.score["south"]["player_score"].to_i

      elsif p_id == game.score["west"]["player_id"].to_i &&
      game.score["west"]["player_score"].to_i == score.sort[place].to_i &&
      game.score["west"]["player_score"].to_i != score.sort[place+1].to_i

        result_array << game.score["west"]["player_score"].to_i

      elsif p_id == game.score["north"]["player_id"].to_i &&
      game.score["north"]["player_score"].to_i == score.sort[place].to_i &&
      game.score["north"]["player_score"].to_i != score.sort[place+1].to_i 

        result_array << game.score["north"]["player_score"].to_i
      else
        # не делаем ничего
      end
    end
    
    return result_array
  end
end
