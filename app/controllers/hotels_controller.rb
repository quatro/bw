class HotelsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index
    @q = Hotel.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:bookings).page(params[:page]).to_a.uniq
  end

  private
  def set_model
    @model = Hotel.where(id: params[:id]) if params[:id]
  end
end