class PlayersController < ApplicationController
  before_action :authenticate_player!

  def all
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end
  def profile
    @player = current_player
  end
end
