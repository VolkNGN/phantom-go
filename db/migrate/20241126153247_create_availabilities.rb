class CreateAvailabilities < ActiveRecord::Migration[7.2]
  def change
    create_table :availabilities do |t|
      t.references :player, null: false, foreign_key: true
      t.timestamps
    end
  end
end
