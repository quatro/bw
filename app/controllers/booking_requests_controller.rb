class BookingRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def new
    @model = BookingRequest.new({tenant_id: current_user.active_tenant.try(:id), assignee_id: current_user.try(:id)})
    @model.booking_request_rooms.build
  end

  def outstanding
    @q = BookingRequest.outstanding_for_tenant(current_user.active_tenant).unassigned.order(id: :asc).ransack(params[:q])
    @models = @q.result(distinct: true).page(params[:page])
  end

  def edit
    if @model.is_booked?
      return redirect_to root_path, alert: 'This request has already been booked and cannot be edited'
    end

  end

  def create
    @model = BookingRequest.new(booking_request_params)

    if @model.save

      # This allows for some fields to be denormalized, particularly ones that rely on some denormalization from BookingRequestRoom
      @model.denormalize

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

  def destroy
    if @model.destroy
      flash[:notice] = "Successfully removed booking request"
    else
      flash[:alert] = "Problem removing booking request: #{@model.errors.full_messages}"
    end

    redirect_to_back
  end

  def show; end

  def my
    @q = current_user.assigned_booking_requests.outstanding.ransack
    @models = @q.result(distinct: true).page(params[:page])
  end

  def release
    if @model.update({assignee: nil})
      redirect_to @model, notice: "#{@model.name} as been unassigned"
    else
      flash[:alert] = "Problem releasing this booking request"
      redirect_to_back
    end
  end

  def book
    br = @model

    # If it's already booked we don't want to book again
    return redirect_to root_path, alert: 'This request has already been booked and cannot be edited' if br.is_booked?

    @model = Booking.new({booking_request: br})

    br.booking_request_rooms.each do |brr|
      @model.booking_rooms.build({booking_request_room: brr, fee: br.client.billing_fee}) if !@model.booking_rooms.select{|br| br.booking_request_room_id == brr.try(:id)}.any?
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
        :requestor_full_name,
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
        booking_request_rooms_attributes:[:id, :guest1_name, :guest2_name, :room_size, :_destroy])
  end
end