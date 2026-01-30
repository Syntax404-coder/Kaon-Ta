module Admin
  class ReservationsController < ApplicationController
    before_action :require_admin

    def index
      @reservations = Reservation.includes(:user, :table).order(created_at: :desc)
    end

    def destroy
      @reservation = Reservation.find(params[:id])

      # Attempt to send cancellation email (fail gracefully if SMTP not configured)
      email_sent = false
      begin
        ReservationMailer.with(reservation: @reservation).cancellation_email.deliver_now
        email_sent = true
      rescue StandardError => e
        Rails.logger.error "Failed to send cancellation email: #{e.message}"
      end

      @reservation.destroy

      if email_sent
        redirect_to admin_dashboard_path, notice: "Reservation cancelled and notification sent to user."
      else
        redirect_to admin_dashboard_path, notice: "Reservation cancelled. (Email notification could not be sent)"
      end
    end
  end
end
