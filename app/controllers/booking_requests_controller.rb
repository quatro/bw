class BookingRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end
  def outstanding
    @models = BookingRequest.outstanding_for_tenant(current_user.active_tenant).unassigned.order(id: :asc).limit(100)
  end

  def edit; end

  def update
    if @model.update(booking_request_params)
      redirect_to @model
    else
      render "edit"
    end
  end

  def show; end

  def my
    @models = current_user.assigned_booking_requests.outstanding
  end

  def book
    br = @model
    @model = Booking.new({booking_request: br})
  end

  def claim_and_book
    @model.update({assignee: current_user})

    redirect_to book_booking_request_path(@model)
  end

  private
  def set_model
    @model = BookingRequest.where(id: params[:id]).first if params[:id]
  end

  def booking_request_params
    params.require(:booking_request).permit(:date_from, :date_to, :city, :state, :zip, :reason, :job_identifier)
  end
end