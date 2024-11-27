class AddNameToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :name, :string
  end
end
