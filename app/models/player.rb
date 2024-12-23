class Player < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games_as_black_player, class_name: 'Game', foreign_key: 'black_player_id'
  has_many :games_as_white_player, class_name: 'Game', foreign_key: 'white_player_id'
  has_many :achievements
  has_many :badges, through: :achievements
  has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'sender_id'
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'receiver_id'

  has_one :availability
  has_one_attached :photo
  has_one_attached :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true
end
