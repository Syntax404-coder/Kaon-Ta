class TablesController < ApplicationController
  before_action :require_login

  MANILA_TIMEZONE = "Asia/Manila".freeze

  def index
    # Get the selected date from params, default to today in Manila time
    manila_zone = ActiveSupport::TimeZone[MANILA_TIMEZONE]
    today_in_manila = Time.current.in_time_zone(manila_zone).to_date

    @selected_date = params[:date].present? ? Date.parse(params[:date]) : today_in_manila

    # Calculate the start and end of the selected day in Manila timezone
    start_of_day = manila_zone.local(@selected_date.year, @selected_date.month, @selected_date.day).beginning_of_day
    end_of_day = manila_zone.local(@selected_date.year, @selected_date.month, @selected_date.day).end_of_day

    # Filter tables for the selected date
    @tables = Table.where(start_time: start_of_day..end_of_day).order(:start_time)

    # Store today's date for the view (for default value)
    @today_date = today_in_manila
  end
end
