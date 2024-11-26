class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :status
      t.integer :turn
      t.references :winner, foreign_key: { to_table: :players }
      t.references :black_player, foreign_key: { to_table: :players }
      t.references :white_player, foreign_key: { to_table: :players }
      t.timestamps
    end
  end
end
