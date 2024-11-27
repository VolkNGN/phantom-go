class AddProfilePictureToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :profile_picture, :string
  end
end
