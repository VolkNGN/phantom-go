class ChangeColumnToTurns < ActiveRecord::Migration[7.2]
  def change
    change_column :turns, :column, :string
  end
end
