class Availability < ApplicationRecord
  belongs_to :player

  # Validations
  validates :player_id, uniqueness: { message: "Player is already in the queue." }

  # Méthode pour rechercher un match
  def self.find_match
    # Récupère la première disponibilité existante (le prochain joueur dans la file)
    Availability.first
  end

  # Méthode pour supprimer une disponibilité après le matchmaking
  def self.clear_availability(availability)
    availability.destroy if availability
  end
end
