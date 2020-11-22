class ClientsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index
    @q = Client.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:bookings).page(params[:page]).to_a.uniq
  end

  private
  def set_model
    @model = Client.where(id: params[:id]) if params[:id]
  end
end