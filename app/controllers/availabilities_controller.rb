class AvailabilitiesController < ApplicationController
  before_action :authenticate_player!
  before_action :set_availability, only: [:destroy]

  def index
    # Récupérer toutes les disponibilités existantes
    @availabilities = Availability.all
  end

  def show
    @availability = Availability.find_by(id: params[:id])

    if @availability.nil?
      redirect_to root_path, alert: "Availability not found."
    end
  end


  # Je veux ajouter un joueur à la file d'attente
  def create
    # Vérifie s'il existe une disponibilité dans la file d'attente
    existing_availability = Availability.first

    if existing_availability
      # Si une disponibilité existe :
      # Je crée une partie entre le joueur actuel et le joueur associé à la disponibilité trouvée
      game = Game.create!(
        black_player: current_player,
        white_player: existing_availability.player,
        status: "ongoing"
      )

      # Supprime la disponibilité utilisée après la création du match
      existing_availability.destroy

      AvailabilitiesChannel.broadcast_to(
        existing_availability,
        { url: game_path(game) }
      )

      redirect_to game_path(game), notice: "Match found! Let's play."
    else
      # Sinon :
      # Je crée une nouvelle disponibilité pour le joueur actuel
      new_availability = Availability.create!(player: current_player)

      # Je redirige le joueur vers la page d'attente (vue `show` de la nouvelle disponibilité)
      redirect_to availability_path(new_availability), notice: "You are now in the queue. Waiting for an opponent..."
    end
  end

  # Retirer un joueur de la file d'attente
  def destroy
    # Supprime la disponibilité sélectionnée
    if @availability.destroy
      # Récupérer la partie en cours pour rediriger
      game = Game.find_by(black_player: current_player) || Game.find_by(white_player: current_player)

      # Redirige vers la page de la partie si elle existe
      if game
        redirect_to game_path(game), notice: "Redirected to your game."
      else
        # Si aucune partie n'existe, redirige vers la liste des parties
        redirect_to games_path, alert: "No game found. Redirected to the games list."
      end
    else
      # Si la suppression échoue, redirige vers la page d'accueil avec un message d'erreur
      redirect_to root_path, alert: "Failed to remove availability."
    end
  end


  # Trouver une disponibilité par ID
  def set_availability
    # Charge la disponibilité correspondant à l'ID fourni
    @availability = Availability.find_by(id: params[:id])

    # Si aucune disponibilité n'est trouvée, redirige avec un message d'erreur
    unless @availability
      redirect_to root_path, alert: "Availability not found."
    end
  end
end
