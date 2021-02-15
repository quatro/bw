class Api::V1::BookingsController < Api::ApplicationController

  def cancel

    hash = params.permit(:id).to_hash
    @model = Booking.find(hash[:id]) if hash[:id]


    if @model.cancel
      render json: {status: 'success', errors:[], model: @model}
    else
      render json:{status: 'error', errors: @model.errors.full_messages}, status: 422
    end

  end



end