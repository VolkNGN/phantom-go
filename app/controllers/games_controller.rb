class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
    if current_player == @game.black_player
      @color = "black"
    else
      @color = "white"
    end
    
  def new
  end
end
