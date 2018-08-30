module ApplicationHelper

  # Выводим имя пользователя и его место, согласна полученым очкам
  def get_player_name(wind, game, players)
    score = [
      game.score["east"]["player_score"].to_i,
      game.score["south"]["player_score"].to_i,
      game.score["west"]["player_score"].to_i,
      game.score["north"]["player_score"].to_i
    ]

    if score.sort[3].to_i == game.score["#{wind}"]["player_score"].to_i then
      "1. " + players.find(game.score["#{wind}"]["player_id"]).name

    elsif score.sort[2].to_i == game.score["#{wind}"]["player_score"].to_i
      "2. " + players.find(game.score["#{wind}"]["player_id"]).name

    elsif score.sort[1].to_i == game.score["#{wind}"]["player_score"].to_i
      "3. " + players.find(game.score["#{wind}"]["player_id"]).name

    elsif score.sort[0].to_i == game.score["#{wind}"]["player_score"].to_i
      "4. " + players.find(game.score["#{wind}"]["player_id"]).name
    else
      "!WTF"
    end
  end

  def score_sum(game)
        game.score["east"]["player_score"].to_i +
        game.score["south"]["player_score"].to_i +
        game.score["west"]["player_score"].to_i +
        game.score["north"]["player_score"].to_i
  end

end
