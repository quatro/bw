class TenantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end

  private
  def set_model
    @model = Tenant.where(id: params[:id]) if params[:id]
  end
end