class Game < ApplicationRecord
  class CoupImpossible < StandardError; end
  class ErreurDeTour < StandardError; end
  class SuicideErreur < StandardError; end
  class KoErreur < StandardError; end

  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :turns
  enum turn: %i[black white]

  def currently_playing
    if turns.empty?
      return black_player
    elsif turns.count.even? # rubocop:disable Lint/DuplicateBranch
      return black_player
    else
      return white_player
    end
  end

  def currently_waiting
    return white_player if currently_playing == black_player

    return black_player
  end

  def currently_playing_color
    return 'black' if currently_playing == black_player

    return 'white'
  end

  def check_captures(goban, stone)
    # je récupère les voisins opposés de la pierre
    neighbours = goban.neighbours(stone)
    opponent_neighbours = neighbours.select do |s|
      stone.color != s.color && !s.color.nil?
    end
    stones_to_remove = []
    # je prends leur groupe
    opponent_neighbours.each do |s|
      group = goban.group(s)
      next unless goban.liberty_count(group) == 0

      group.each do |stone|
        stones_to_remove << stone
        stone.remove
      end
    end
    # Pour chaque groupe, s'il n'a plus de libertés, je le retire
    return stones_to_remove
  end

  def play(color, column, row)
    # Je dois créer un goban
    goban = Goban.new(self)
    # Je dois créer une pierre
    stone = Stone.new(color, column, row, goban)
    # je regarde si c'est la bonne couleur qui joue
    if stone.color != currently_playing_color
      # Si c'est pas le cas, je renvoie une erreur
      raise ErreurDeTour
    end
    # je regarde s'il y a déjà une pierre à cet endroit
    # si c'est le cas, on renvoie une erreur
    raise CoupImpossible unless goban.free_intersection?(stone)

    stone.place
    # on déclenche les captures
    captured_stones = check_captures(goban, stone)

    # on vérifie les situations de suicide
    # s'il y a suicide, on envoie un message d'erreur
    group = goban.group(stone)
    raise SuicideErreur if goban.liberty_count(group) == 0

    # on vérifie les situations de ko
    # s'il y a ko, on envoie un message d'erreur

    # on créé un nouveau turn
    Turn.create(column: column, row: row, game: self, turn_number: turns.count + 1, score: captured_stones.count)
  end
end
