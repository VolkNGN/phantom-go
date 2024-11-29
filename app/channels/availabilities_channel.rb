class AvailabilitiesChannel < ApplicationCable::Channel
  def subscribed
    availability = Availability.find(params[:id])
    stream_for(availability)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
