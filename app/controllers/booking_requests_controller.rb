class BookingRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end
  def outstanding
    @models = BookingRequest.outstanding_for_tenant(current_user.active_tenant)
  end

  def book

  end

  private
  def set_model
    @model = BookingRequest.where(id: params[:id]) if params[:id]
  end
end