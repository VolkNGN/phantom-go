class Turn < ApplicationRecord
  belongs_to :game

  def color
    if turn_number.odd?
      return "black"
    else
      return "white"
    end
  end
end
