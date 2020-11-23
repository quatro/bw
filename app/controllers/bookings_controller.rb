class BookingsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def completed
    @q = Booking.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  def create
    @model = Booking.new(booking_params)

    if @model.save
      redirect_to @model
    end
  end

  def show

  end

  private
  def set_model
    @model = Booking.where(id: params[:id]).first if params[:id]
  end

  def booking_params
    params.require(:booking).permit(:rate, :tax, :hotel_id, :booking_request_id, :requestor_id, :client_id, :assignee_id)
  end
end