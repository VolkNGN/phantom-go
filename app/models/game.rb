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

  def color_of(player)
    if player == black_player
      "black"
    else
      "white"
    end
  end

  def next_turn
    return 1 if turns.empty?

    turns.last.turn_number + 1
  end

  def check_captures(stone)
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

  def goban
    return @goban if @goban

    @goban = Goban.new(self)
    @goban.prepare
    @goban
  end

  def play(color, column, row, turn_number)
    # Je dois créer une pierre
    stone = Stone.new(color, column, row, goban)

    # je regarde si c'est la bonne couleur qui joue
    if stone.color == "black" && turn_number.even?
      # Si c'est pas le cas, je renvoie une erreur
      raise ErreurDeTour
    end
    if stone.color == "white" && turn_number.odd?
      # Si c'est pas le cas, je renvoie une erreur
      raise ErreurDeTour
    end
    # je regarde s'il y a déjà une pierre à cet endroit
    # si c'est le cas, on renvoie une erreur
    raise CoupImpossible unless goban.free_intersection?(stone)

    stone.place
    # on déclenche les captures
    captured_stones = check_captures(stone)

    # on vérifie les situations de suicide
    # s'il y a suicide, on envoie un message d'erreur
    # group = goban.group(stone)
    # raise SuicideErreur if goban.liberty_count(group) == 0

    # on vérifie les situations de ko
    # s'il y a ko, on envoie un message d'erreur

    # on créé un nouveau turn si on n'est pqs entrqin de rejouer la partie pour recréer le goban
    return unless turn_number > turns.last.turn_number

    Turn.create(column: column, row: row, game: self, turn_number: turns.count + 1, score: captured_stones.count)
  end
end
