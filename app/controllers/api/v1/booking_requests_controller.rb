class Api::V1::BookingRequestsController < Api::ApplicationController

  def create

    hash = params.permit(:date_from, :date_to, :city, :state, :reason, :zip, :job_identifier).to_hash
    @model = BookingRequest.new(hash)
    @model.requestor = @current_api_user
    @model.client = @current_api_user.client
    @model.tenant = @current_api_user.client.try(:tenant)

    if @model.save
      render json: {status: 'success', errors:[], model: @model}
    else
      render json:{status: 'error', errors: @model.errors.full_messages}, status: 422
    end

  end



end