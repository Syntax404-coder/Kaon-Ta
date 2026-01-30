module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      @reservations = Reservation.joins(:table, :user)
                                 .includes(:table, :user)
                                 .order("tables.start_time DESC")
    end
  end
end
