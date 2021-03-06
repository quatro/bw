class BookingsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def completed
    @q = Booking.for_tenant(current_user.active_tenant).completed.paf_not_sent.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def is_paf_sent
    @q = Booking.for_tenant(current_user.active_tenant).is_paf_sent.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def is_folio_received
    @q = Booking.for_tenant(current_user.active_tenant).is_folio_received.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def is_invoiced
    @q = Booking.for_tenant(current_user.active_tenant).is_invoiced.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def is_paid
    @q = Booking.for_tenant(current_user.active_tenant).is_paid.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def list_cancelled
    @q = Booking.for_tenant(current_user.active_tenant).cancelled.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
  end

  def list_no_show
    @q = Booking.for_tenant(current_user.active_tenant).no_show.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page])
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
    mark(:is_paf_sent, "PAF Sent")
  end

  def mark_invoiced
    mark(:is_invoiced, "Invoiced")
  end

  def mark_paid
    mark(:is_paid, 'Paid')
  end

  private
  def set_model
    @model = Booking.where(id: params[:id]).first if params[:id]
  end

  def mark(prop, text)
    @model.send("#{prop}=", true)

    if @model.save
      flash[:notice] = "Successfully marked as #{text}"
      redirect_to_back
    else
      flash[:alert] = "Error marking #{text}: #{@model.errors.full_messages}"
      redirect_to_back
    end
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
        :is_folio_received,
        booking_rooms_attributes: [
            :id,
            :confirmation_number,
            :rate,
            :internal_rate,
            :room_number,
            :booking_request_room_id,
            :tax,
            :fee,
            :total,
            :internal_total
        ]
    )
  end
end