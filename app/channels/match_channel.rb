class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "match_channel_player_#{current_player.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
