class ReservationMailer < ApplicationMailer
  default from: "domenicrobiataganahan@gmail.com"

  def cancellation_email
    @reservation = params[:reservation]
    @user = @reservation.user
    @table = @reservation.table

    mail(to: @user.email, subject: "Reservation Cancellation Notice")
  end

  def confirmation_email
    @reservation = params[:reservation]
    @user = @reservation.user
    @table = @reservation.table

    mail(to: @user.email, subject: "Reservation Confirmed - Kaon Ta!")
  end
end
