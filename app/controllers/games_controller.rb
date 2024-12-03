class GamesController < ApplicationController
  before_action :authenticate_player! # S'assurer que le joueur est connecté
  before_action :set_game, only: %i[show edit update destroy play pass give_up]
  before_action :set_last_turn, only: %i[show play]
  before_action :set_channel, only: %i[play pass]

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
    if current_player == @currently_playing
      @message = "A vous de jouer"
    else
      @message = "C'est à votre adversaire de jouer"
    end
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

    if @game.turns.any? && @game.turns.find_by(column: params[:column], row: params[:row])
      stream_message_to_currently_playing("Coup impossible")
      return head :unprocessable_entity
    else
      @turn = Turn.new
      @turn.column = params[:column]
      @turn.row = params[:row]
      @turn.game = @game
      @turn.turn_number = @game.turns.count + 1
      @turn.save
      stream_message_to_currently_playing("A votre adversaire de jouer")
      # sleep 0.5
      stream_message_to_currently_waiting("A vous de jouer")
      # recupérer la game et le joueur currently waiting
      # render json: { message: "Pierre superbement posée !", turn: @turn }, status: :created
    end
    head :ok
    # le serveur repond au black player
    # if @turn.save
    # else
    #   render json: { message: @turn.errors.full_messages.join(", ") }, status: :unprocessable_entity
    # end
    # puts @turn.game
    # render turbo_stream: turbo_stream.update(
    #   :referee_disclaimer,
    #   partial: "games/referee_disclaimer",
    #   locals: { text: text }
    # )
  end

  def pass
    # puts "-------------------------"
    # puts "pass"
    # Il faut regarder si le tour d'avant est un pass alors c'est game over
    @game.turns.create(turn_number: @game.turns.count + 1)
    redirect_to game_path(@game)
  end

  def give_up
    @game.update(winner_id: @currently_waiting.id, status: "finished")
    redirect_to game_path(@game), notice: "#{@currently_waiting} a remporté la partie !"
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

  def set_channel
    @channel_adress = "#{@game.to_gid_param}:#{@currently_waiting.to_gid_param}"
  end

  def stream_message_to_currently_playing(message)
    channel_adress = "#{@game.to_gid_param}:#{@currently_playing.to_gid_param}"

    stream_message(message, channel_adress)
  end

  def stream_message_to_currently_waiting(message)
    channel_adress = "#{@game.to_gid_param}:#{@currently_waiting.to_gid_param}"

    stream_message(message, channel_adress)
  end

  def stream_message(message, channel_adress)
    GameChannel.broadcast_to(
      channel_adress,
      html: turbo_stream.update(
        "message",
        partial: "games/referee_disclaimer",
        locals: { text: message }
      )
    )
  end
end
