json.extract! player, :id, :name, :nickname, :activated, :created_at, :updated_at
json.url player_url(player, format: :json)
