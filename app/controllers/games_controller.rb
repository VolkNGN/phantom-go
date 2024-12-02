class GamesController < ApplicationController
  before_action :authenticate_player! # S'assurer que le joueur est connecté
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # Lister toutes les parties
  def index
    @games = Game.all
    render json: @games
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

  # Jouer un tour dans une partie
  def play_turn
    @game = Game.find(params[:id])

    turn = Turn.new(turn_params)
    turn.game = @game
    turn.turn_number = @game.turns.count + 1

    if turn.save
      render json: { message: "Turn played successfully.", turn: turn }, status: :ok
    else
      render json: { message: turn.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  # Charger une partie spécifique
  def set_game
    @game = Game.find_by(id: params[:id])
  end

  # Filtrer les paramètres pour la création/mise à jour d'une partie
  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id, :status, :winner_id)
  end

  # Filtrer les paramètres pour jouer un tour
  def turn_params
    params.require(:turn).permit(:row, :column, :score)

  def show
    @game = Game.find(params[:id])
    if current_player == @game.black_player
      @color = "black"
    else
      @color = "white"
    end
  end

  def new

  end
end
