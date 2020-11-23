class BookingRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end
  def outstanding
    @models = BookingRequest.outstanding_for_tenant(current_user.active_tenant).unassigned
  end

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
end