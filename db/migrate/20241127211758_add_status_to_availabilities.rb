class AddStatusToAvailabilities < ActiveRecord::Migration[7.2]
  def change
    add_column :availabilities, :status, :string
  end
end
