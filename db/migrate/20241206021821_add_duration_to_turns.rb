class AddDurationToTurns < ActiveRecord::Migration[7.2]
  def change
    add_column :turns, :duration, :integer
  end
end
