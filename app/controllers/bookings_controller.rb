class BookingsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  def completed
    @q = Booking.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:booking_request).page(params[:page]).to_a.uniq
  end

  private
  def set_model
    @model = Booking.where(id: params[:id]) if params[:id]
  end
end