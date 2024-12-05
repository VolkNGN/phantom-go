class Stone
  attr_reader :color, :column, :row

  def initialize(color, column, row, goban)
    @color = color
    @column = column
    @row = row
    @goban = goban
  end

  # Je veux pouvoir placer une pierre sur le goban
  def place
    @goban.place_stone(self)
  end

  # Je veux pouvoir retirer une pierre du goban
  def remove
    @goban.remove_stone(self)
  end

  def to_s
    "<Stone #{color} at #{column}#{row}>"
  end

  def inspect
    to_s
  end
end
