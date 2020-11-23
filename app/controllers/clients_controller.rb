class ClientsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def index
    @q = Client.ransack(params[:q])
    @models = @q.result(distinct: true).includes(:bookings).page(params[:page]).to_a.uniq
  end

  def new
    @model = Client.new({tenant_id: params[:tenant_id]})
  end

  def edit; end

  def create
    @model = Client.new(client_params)
    @model.tenant_id = params[:tenant_id]

    if @model.save
      redirect_to [@model.tenant, @model]
    else
      render "new"
    end
  end

  def update
    if @model.update(client_params)
      redirect_to [@model.tenant, @model]
    else
      render "edit"
    end
  end

  def show

  end

  private
  def set_model
    @model = Client.where(id: params[:id]).first if params[:id]
  end

  def client_params
    params.require(:client).permit(:name, :tenant_id)
  end
end