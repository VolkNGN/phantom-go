class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    if current_player == @game.black_player
      @color = "black"
    else
      @color = "white"
    end
    puts @game
  end

  def new
  end

  def play
    puts "//////////////////////////////////////////////////"
    @game = Game.find(params[:id])
    @turn = Turn.new
    @turn.column = params[:column]
    @turn.row = params[:row]
    @turn.game = @game
    @turn.save
    puts @turn.game
  end
end
