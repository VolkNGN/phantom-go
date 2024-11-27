class PlayersController < ApplicationController
  before_action :authenticate_player!

  def show
    @player = Player.find(params[:id])
  end
end
