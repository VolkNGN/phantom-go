class GamesController < ApplicationController
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

  def play
    puts "//////////////////////////////////////////////////"
    puts params
    @game = Game.find(params[:id])
    @game.turn = params[:color]
    @game.turn = params[:column]
    # @game.turn = params[:row]
    @game.save
    puts @game
  end
end
