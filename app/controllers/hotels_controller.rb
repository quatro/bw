class HotelsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index
    @q = Hotel.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:bookings).page(params[:page]).to_a.uniq
  end

  def new
    @model = Hotel.new({tenant_id: params[:tenant_id]})
  end

  def edit; end

  def create
    @model = Hotel.new(hotel_params)
    @model.tenant_id = params[:tenant_id]

    if @model.save

      redirect_to [@model.tenant, @model]
    else
      render "new"
    end
  end

  def update
    if @model.update(hotel_params)
      redirect_to [@model.tenant, @model]
    else
      render "edit"
    end
  end

  def show

  end

  def map_markers
    return render json: Hotel.all
  end

  private
  def set_model
    @model = Hotel.where(id: params[:id]).first if params[:id]
  end

  def hotel_params
    params.require(:hotel).permit(:name, :tenant_id, :address, :city, :state, :zip, :rate)
  end
end