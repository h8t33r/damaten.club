class AddRankToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :rank, :integer, :default => 1500
  end
end
