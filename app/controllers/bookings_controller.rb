class BookingsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def completed
    @q = Booking.for_tenant(current_user.active_tenant).completed.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  def list_cancelled
    @q = Booking.for_tenant(current_user.active_tenant).cancelled.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  def list_no_show
    @q = Booking.for_tenant(current_user.active_tenant).no_show.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  def create
    @model = Booking.new(booking_params)

    if @model.save
      redirect_to @model
    end
  end

  def edit; end

  def show

  end

  def cancel
    if @model.cancel
      redirect_to @model, notice: 'Successfully cancelled this booking'
    else
      flash[:alert] = "Unable to cancel this booking: #{@model.errors.full_messages}"
      redirect_to_back
    end
  end

  def no_show
    if @model.no_show
      redirect_to @model, notice: 'Successfully set this booking as a no-show'
    else
      flash[:alert] = "Unable to set this booking as a no-show: #{@model.errors.full_messages}"
      redirect_to_back
    end
  end

  private
  def set_model
    @model = Booking.where(id: params[:id]).first if params[:id]
  end

  def booking_params
    params.require(:booking).permit(:rate, :tax, :assignee_id, :hotel_id, :booking_request_id, :requestor_id, :client_id, :assignee_id, :confirmation_number)
  end
end