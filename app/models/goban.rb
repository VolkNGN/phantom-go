class Goban
  COLUMNS = ["A", "B", "C", "D", "E", "F"]

  def initialize(game)
    # historique des coups
    @game = game
    # état actuel
    @stones_list = [
      [FreeIntersection.new("A", 6), FreeIntersection.new("B", 6), FreeIntersection.new("C", 6),
       FreeIntersection.new("D", 6), FreeIntersection.new("E", 6), FreeIntersection.new("F", 6)],
      [FreeIntersection.new("A", 5), FreeIntersection.new("B", 5), FreeIntersection.new("C", 5),
       FreeIntersection.new("D", 5), FreeIntersection.new("E", 5), FreeIntersection.new("F", 5)],
      [FreeIntersection.new("A", 4), FreeIntersection.new("B", 4), FreeIntersection.new("C", 4),
       FreeIntersection.new("D", 4), FreeIntersection.new("E", 4), FreeIntersection.new("F", 4)],
      [FreeIntersection.new("A", 3), FreeIntersection.new("B", 3), FreeIntersection.new("C", 3),
       FreeIntersection.new("D", 3), FreeIntersection.new("E", 3), FreeIntersection.new("F", 3)],
      [FreeIntersection.new("A", 2), FreeIntersection.new("B", 2), FreeIntersection.new("C", 2),
       FreeIntersection.new("D", 2), FreeIntersection.new("E", 2), FreeIntersection.new("F", 2)],
      [FreeIntersection.new("A", 1), FreeIntersection.new("B", 1), FreeIntersection.new("C", 1),
       FreeIntersection.new("D", 1), FreeIntersection.new("E", 1), FreeIntersection.new("F", 1)]
    ]
    read_turns_list
  end

  # Je veux pouvoir placer une pierre sur le goban
  def place_stone(stone)
    column_as_integer = COLUMNS.index(stone.column)
    @stones_list[6 - stone.row][column_as_integer] = stone
  end

  # Je veux pouvoir retirer une pierre du goban
  def remove_stone(stone)
    column_as_integer = COLUMNS.index(stone.column)
    @stones_list[6 - stone.row][column_as_integer] = FreeIntersection.new(stone.column, stone.row)
  end

  # Je veux définir un groupe de pierre, il s'agit du groupe de pierre auquel appartient la pierre donnée
  def group(stone)
    group = []
    queue = [stone]
    # tant que queue n'est pas vide
    until queue.empty?
      # je prends la prochaine pierre de la queue et je la stocke
      new_stone = queue.shift
      # je la mets dans le groupe
      group << new_stone
      # je prends ses voisins et je les mets dans la queue s'ils ne sont pas déjà dans le groupe
      neighbours(new_stone).each do |neighbour|
        queue << neighbour if !group.include?(neighbour) && neighbour.color == new_stone.color
      end
    end
    return group
  end

  # Je veux compter le nombre de libertés d'un groupe de pierres. Une liberté est une intersection vide adjacente à une pierre du groupe.
  def liberty_count(group)
    # Je prends chaque pierre du groupe
    free_intersections = []
    group.each do |stone|
      # Je regarde si le voisin a une couleur nil
      # Je stocke le tout dans un tableau
      neighbours(stone).each do |neighbour|
        free_intersections << neighbour if neighbour.color.nil?
      end
    end
    # faire un .uniq pour ne pas compter plusieurs fois la même intersection
    # on compte les éléments du tableau
    return free_intersections.uniq.count
  end

  # Je veux connaître les pierres adjacentes à une pierre donnée
  def neighbours(stone)
    [
      neighbour_from_top(stone),
      neighbour_from_bottom(stone),
      neighbour_from_left(stone),
      neighbour_from_right(stone)
    ].compact
  end

  def neighbour_from_top(stone)
    return nil if stone.row == 6

    column_as_integer = COLUMNS.index(stone.column)
    @stones_list[6 - stone.row - 1][column_as_integer]
  end

  def neighbour_from_bottom(stone)
    return nil if stone.row == 1

    column_as_integer = COLUMNS.index(stone.column)
    @stones_list[6 - stone.row + 1][column_as_integer]
  end

  def neighbour_from_left(stone)
    return nil if stone.column == "A"

    column_as_integer = COLUMNS.index(stone.column) - 1
    @stones_list[6 - stone.row][column_as_integer]
  end

  def neighbour_from_right(stone)
    return nil if stone.column == "F"

    column_as_integer = COLUMNS.index(stone.column) + 1
    @stones_list[6 - stone.row][column_as_integer]
  end

  def free_intersection?(stone)
    intersection = goban.stones_list[6 - stone.row][COLUMNS.index(stone.column)]
    return true if intersection.color.nil?

    return false
  end

  private

  def read_turns_list
    # Je vais prendre chaque coup de la move_list et le jouer
    @game.turns.each do |turn|
      @game.play(turn.color, turn.column, turn.row)
    end
  end
end
