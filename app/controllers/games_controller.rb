class GamesController < ApplicationController
  before_action :authenticate_player! # S'assurer que le joueur est connecté
  before_action :set_game, only: %i[show play pass give_up]

  # Méthode show affiche la couleur du current_player
  def show
    @goban = @game.goban
    @color = @game.color_of(current_player)

    if current_player == @currently_playing
      @message = "A vous de jouer"
    else
      @message = "C'est à votre adversaire de jouer"
    end
  end

  # Méthode play permet de jouer un tour en récupérant les infos du turn(column, row, color)
  def play
    @game.play(params[:color], params[:column], params[:row].to_i, @game.next_turn)

    stream_message_to_currently_playing("A votre adversaire de jouer")

    stream_message_to_opponent("A vous de jouer")
    stream_goban_to_opponent

    head :ok
  rescue Game::CoupImpossible, Game::SuicideErreur
    stream_message_to_currently_playing("Coup impossible !")
    head :unprocessable_entity
  rescue Game::ErreurDeTour
    stream_message_to_currently_playing("Ça n'est pas à vous de jouer !")
    head :unprocessable_entity
  end

  def pass
    # Il faut regarder si le tour d'avant est un pass alors c'est game over
    # @game.turns.create(turn_number: @game.turns.count + 1)
    redirect_to game_result_path(@game)
  end

  def give_up
    @game.update(winner_id: @currently_waiting.id, status: "finished")
    redirect_to game_path(@game), notice: "#{@currently_waiting} a remporté la partie !"
  end

  def result
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

  def stream_message_to_currently_playing(message)
    channel_adress = "#{@game.to_gid_param}:#{@currently_playing.to_gid_param}"

    stream_message(message, channel_adress)
  end

  def stream_message_to_opponent(message)
    channel_adress = "#{@game.to_gid_param}:#{@currently_waiting.to_gid_param}"

    stream_message(message, channel_adress)
  end

  def stream_message(message, channel_adress)
    GameChannel.broadcast_to(
      channel_adress,
      html: turbo_stream.update(
        "referee-message-container",
        partial: "games/referee_disclaimer",
        locals: { message: message }
      )
    )
  end

  def stream_goban_to_opponent
    channel_adress = "#{@game.to_gid_param}:#{@currently_waiting.to_gid_param}"

    color = @game.color_of(@currently_waiting)

    GameChannel.broadcast_to(
      channel_adress,
      html: turbo_stream.update(
        "goban",
        partial: "games/goban",
        locals: { game: @game, goban: @game.goban, color: color }
      )
    )
  end
end
