class CreateTurns < ActiveRecord::Migration[7.2]
  def change
    create_table :turns do |t|
      t.integer :turn_number
      t.integer :row
      t.integer :column
      t.integer :score
      t.references :game, null: false, foreign_key: true
      t.timestamps
    end
  end
end
