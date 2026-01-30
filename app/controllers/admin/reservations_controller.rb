module Admin
  class ReservationsController < ApplicationController
    before_action :require_admin

    def index
      @reservations = Reservation.includes(:user, :table).order(created_at: :desc)
    end

    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy
      redirect_to admin_dashboard_path, notice: "Reservation cancelled successfully."
    end
  end
end
