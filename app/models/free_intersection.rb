class FreeIntersection
  attr_reader :column, :row, :color

  def initialize(column, row)
    @column = column
    @row = row
    @color = nil
  end

  def to_s
    "<Intersection>"
  end

  def inspect
    to_s
  end
end
