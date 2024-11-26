class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :availabilities
  has_many :games_as_black_player, class_name: 'Game', foreign_key: 'black_player_id'
  has_many :games_as_white_player, class_name: 'Game', foreign_key: 'white_player_id'
  has_many :achievements
  has_many :badges, through: :achievements
  has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'sender_id'
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'receiver_id'
end
