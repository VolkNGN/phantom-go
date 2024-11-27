class AddFirstAndLastNameToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :first_name, :string
    add_column :players, :last_name, :string
  end
end
