class Game < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :turns
  enum turn: %i[black white]
end
