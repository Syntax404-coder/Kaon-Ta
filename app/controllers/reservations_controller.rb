class ReservationsController < ApplicationController
  before_action :require_login

  def new
    @table = Table.find(params[:table_id])
    @reservation = current_user.reservations.build(table: @table, guest_count: 1)
  end

  def create
    @table = Table.find(params[:table_id])
    @reservation = current_user.reservations.build(
      table: @table,
      guest_count: params[:guest_count].to_i
    )

    if @reservation.save
      redirect_to tables_path, notice: "Reservation confirmed!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @reservations = current_user.reservations.joins(:table).order("tables.start_time ASC")
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@reservation) }
      format.html { redirect_to my_reservations_path, notice: "Reservation cancelled successfully." }
    end
  end
end
