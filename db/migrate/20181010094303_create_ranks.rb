class CreateRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :ranks do |t|
      t.integer :player_id
      t.integer :rating_change

      t.timestamps
    end
  end
end
