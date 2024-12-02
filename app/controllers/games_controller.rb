class GamesController < ApplicationController
  before_action :set_game, only: %i[show play]
  before_action :set_last_turn, only: %i[show play]

  def index
    @games = Game.all
  end

  # Méthode show affiche la couleur du current_player
  def show
    if current_player == @game.black_player
      @color = "black"
    else
      @color = "white"
    end
    @turns = @game.turns
    # puts @game
  end

  # Méthode stone_color affiche la couleur en fonction du tour
  def stone_color(turn)
    return "black" if turn.turn_number.odd?

    return "white"
  end
  helper_method :stone_color

  def new
  end

  # Méthode play permet de jouer un tour en récupérant les infos du turn(column, row, color)
  def play
    return if !@last_turn.nil? && stone_color(@last_turn) == params[:color]

    @turn = Turn.new
    @turn.column = params[:column]
    @turn.row = params[:row]
    @turn.game = @game
    @turn.turn_number = @game.turns.count + 1
    @turn.save
    # puts @turn.game
  end

  private

  # Méthode set_game permet de récupérer la partie en fonction de l'id
  def set_game
    @game = Game.find(params[:id])
  end

  # Méthode set_last_turn permet de récupérer le dernier tour
  def set_last_turn
    @last_turn = @game.turns.last
  end
end
