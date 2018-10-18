class AddGamescountToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :games_count, :integer, :default => 0

  end
end
