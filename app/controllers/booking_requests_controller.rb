class BookingRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def new
    @model = BookingRequest.new({tenant_id: current_user.active_tenant.try(:id), assignee_id: current_user.try(:id)})
    @model.booking_request_rooms.build
  end

  def outstanding
    @models = BookingRequest.outstanding_for_tenant(current_user.active_tenant).unassigned.order(id: :asc).limit(100)
  end

  def edit
    if @model.is_booked?
      return redirect_to root_path, alert: 'This request has already been booked and cannot be edited'
    end

  end

  def create
    @model = BookingRequest.new(booking_request_params)

    if @model.save
      redirect_to book_booking_request_path(@model)
    else
      render "new"
    end
  end

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

    # If it's already booked we don't want to book again
    return redirect_to root_path, alert: 'This request has already been booked and cannot be edited' if br.is_booked?

    @model = Booking.new({booking_request: br})

    br.booking_request_rooms.each do |brr|
      @model.booking_rooms.build({booking_request_room: brr}) if !@model.booking_rooms.select{|br| br.booking_request_room_id == brr.try(:id)}.any?
    end
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
    params
      .require(:booking_request)
      .permit(
        :assignee_id, 
        :tenant_id, 
        :requestor_id, 
        :client_id, 
        :date_from, 
        :date_to, 
        :city, 
        :state, 
        :zip, 
        :reason, 
        :job_identifier, 
        :address, 
        :number_of_rooms,  
        :customer_id, 
        :new_customer_name,
        booking_request_rooms_attributes:[:id, :guest1_name, :guest2_name, :_destroy])
  end
end