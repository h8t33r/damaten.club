module PlayersHelper

  def results_counter(games, p_id, place)

    result_array = []

    games.each do |game|

      score = [
        game.score["east"]["player_score"].to_i,
        game.score["south"]["player_score"].to_i,
        game.score["west"]["player_score"].to_i,
        game.score["north"]["player_score"].to_i
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

  def color_rating(rating)
    case rating
    when 0 .. 999
      "616161"
    when 1000 .. 1399
      "b71c1c"
    when 1400 .. 1499
      "ff9800"
    when 1500 .. 1599
      "00c853"
    when 1600 .. 1699
      "2196f3"
    else
      "9c27b0"      
    end
    
  end
end
