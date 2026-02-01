class ReservationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reservations"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
