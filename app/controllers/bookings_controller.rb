class BookingsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def completed
    @q = Booking.for_tenant(current_user.active_tenant).completed.paf_not_sent.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  def is_paf_sent
    @q = Booking.for_tenant(current_user.active_tenant).is_paf_sent
             .ransack(params[:q])
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
    else
      render 'new'
    end
  end

  def edit; end
  def show; end

  def update
    if @model.update(booking_params)
      redirect_to @model
    else
      render "edit"
    end
  end

  def resend_email

    # TODO - send email
    @model.send_confirmation_email

    flash[:info] = "Successfully re-sent email"
    redirect_to_back
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

  def mark_paf_sent
    if @model.update({is_paf_sent: true})
      flash[:notice] = "Successfully marked as PAF sent"
      redirect_to_back
    else
      flash[:alert] = "Error marking PAF as sent: #{@model.errors.full_messages}"
      redirect_to_back
    end
  end

  private
  def set_model
    @model = Booking.where(id: params[:id]).first if params[:id]
  end

  def booking_params
    params.require(:booking).permit(
        :tax,
        :assignee_id,
        :hotel_id,
        :booking_request_id,
        :requestor_id,
        :client_id,
        :assignee_id,
        booking_rooms_attributes: [
            :confirmation_number,
            :rate,
            :room_number,
            :booking_request_room_id
        ]
    )
  end
end