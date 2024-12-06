class Turn < ApplicationRecord
  belongs_to :game

  before_save :set_duration

  def color
    if turn_number.odd?
      return "black"
    else
      return "white"
    end
  end

  def set_duration
    end_of_turn = created_at || Time.now
    self.duration = if turn_number == 1
                      (end_of_turn - game.created_at).round
                    else
                      (end_of_turn - game.turns.find_by(turn_number: turn_number - 1).created_at).round
                    end
  end
end
