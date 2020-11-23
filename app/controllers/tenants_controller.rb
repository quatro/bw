class TenantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end



  def hotel
    render json: Hotel.where(id: params[:hotel_id]).first
  end

  private
  def set_model
    @model = Tenant.where(id: params[:id]).first if params[:id]
  end
end