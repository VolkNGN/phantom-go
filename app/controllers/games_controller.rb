class GamesController < ApplicationController
  before_action :authenticate_player! # S'assurer que le joueur est connecté
  before_action :set_game, only: %i[show edit update destroy play]
  before_action :set_last_turn, only: %i[show play]

  # Lister toutes les parties
  def index
    @games = Game.all
  end

  # Formulaire pour créer une nouvelle partie
  def new
    @game = Game.find(params[:id]) # Récupérer la partie en fonction de l'URL
  end

  # Créer une nouvelle partie
  def create
    @game = Game.new(game_params)
    @game.status = "ongoing"

    if @game.save
      render json: { message: "Game created successfully.", game: @game }, status: :created
    else
      render json: { message: @game.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # Mettre à jour une partie existante
  def update
    if @game.update(game_params)
      render json: { message: "Game updated successfully.", game: @game }, status: :ok
    else
      render json: { message: @game.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  # Supprimer une partie
  def destroy
    if @game.destroy
      render json: { message: "Game deleted successfully." }, status: :ok
    else
      render json: { message: "Failed to delete game." }, status: :unprocessable_entity
    end
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
  def last_stone_color(turn)
    return "black" if turn&.turn_number&.odd?

    return "white"
  end
  helper_method :last_stone_color

  # Méthode play permet de jouer un tour en récupérant les infos du turn(column, row, color)
  def play
    return if last_stone_color(@last_turn) == params[:color]

    @turn = Turn.new
    @turn.column = params[:column]
    @turn.row = params[:row]
    @turn.game = @game
    @turn.turn_number = @game.turns.count + 1
    # @turn.save
    # recupérer la game et le joueur currently waiting
    channel_adress = "#{@game.id}:#{@currently_waiting.id}"
    puts channel_adress
    GameChannel.broadcast_to(channel_adress, "C'est ton tour !")
    # le serveur repond au black player
    if @turn.save
      render json: { message: "Pierre superbement posée !", turn: @turn }, status: :created
    else
      render json: { message: @turn.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
    # puts @turn.game
  end

  private

  # Charger une partie spécifique
  def set_game
    @game = Game.find_by(id: params[:id])
    @currently_playing = @game.currently_playing
    @currently_waiting = @game.currently_waiting
  end

  # Filtrer les paramètres pour la création/mise à jour d'une partie
  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id, :status, :winner_id)
  end

  # Filtrer les paramètres pour jouer un tour
  def turn_params
    params.require(:turn).permit(:row, :column, :score)
  end

  # Méthode set_last_turn permet de récupérer le dernier tour
  def set_last_turn
    @last_turn = @game.turns.last
  end
end
