class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find(params[:gameid])
    player = Player.find(params[:playerid])
    stream_from "game:#{game.to_gid_param}:#{player.to_gid_param}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
