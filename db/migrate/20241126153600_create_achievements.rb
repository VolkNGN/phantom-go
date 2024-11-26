class CreateAchievements < ActiveRecord::Migration[7.2]
  def change
    create_table :achievements do |t|
      t.references :player, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true
      t.timestamps
    end
  end
end
