class Game < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :turns
  enum turn: %i[black white]

  def currently_playing
    if turns.empty?
      return black_player
    elsif turns.last.even? # rubocop:disable Lint/DuplicateBranch
      return black_player
    else
      return white_player
    end
  end

  def currently_waiting
    return white_player if currently_playing == black_player

    return black_player
  end
end
