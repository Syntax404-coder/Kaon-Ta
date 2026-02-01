module Admin
  class ReservationsController < ApplicationController
    before_action :require_admin

    def index
      redirect_to admin_dashboard_path
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

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@reservation) }
        format.html do
          if email_sent
            redirect_to admin_dashboard_path, notice: "Reservation cancelled and notification sent to user."
          else
            redirect_to admin_dashboard_path, notice: "Reservation cancelled. (Email notification could not be sent)"
          end
        end
      end
    end
  end
end
