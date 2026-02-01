module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      manila_now = Time.now.in_time_zone("Asia/Manila")
      @selected_date = params[:date] ? Date.parse(params[:date]) : manila_now.to_date
      
      # Lazy Generation: Ensure slots exist for the selected date
      TableGenerator.generate_for_date(@selected_date)

      @cutoff_time = Time.utc(manila_now.year, manila_now.month, manila_now.day, manila_now.hour, manila_now.min, manila_now.sec)

      @reservations = Reservation.joins(:table, :user)
                                 .includes(:table, :user)
                                 .order("tables.start_time DESC")

      @tables = Table.where(start_time: @selected_date.all_day).order(:start_time)

      # Monthly Calendar Stats
      start_of_month = @selected_date.beginning_of_month
      end_of_month = @selected_date.end_of_month
      
      month_reservations = Reservation.joins(:table)
                                      .where(tables: { start_time: start_of_month.beginning_of_day..end_of_month.end_of_day })
      
      # Sum guest_count instead of just counting reservations
      @daily_counts = month_reservations.to_a.group_by { |r| r.table.start_time.to_date }.transform_values { |reservations| reservations.sum(&:guest_count) }
    end

    def toggle_slot
      @table = Table.find(params[:id])
      @table.update!(is_closed: !@table.is_closed)
      redirect_to admin_dashboard_path, notice: "Slot #{@table.is_closed ? 'closed' : 'opened'} successfully."
    end
  end
end
