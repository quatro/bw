class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index
    @models = User.for_tenant(current_user.active_tenant)
  end

  def bookings
    @models = @model.bookings
  end

  private
  def set_model
    @model = Uuser.where(id: params[:id]) if params[:id]
  end
end