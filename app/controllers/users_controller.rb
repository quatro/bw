class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index
    @models = User.for_tenant(current_user.active_tenant)
  end

  def staff
    @models = User.for_tenant(current_user.active_tenant)
  end

  def bookings
    @models = @model.bookings
  end

  def show

  end

  def client_users
    client = Client.where(id: params[:client_id]).first if params[:client_id]

    render json: client.present? ? client.try(:users) : []
  end

  def new
    @model = User.new({tenant_id: params[:tenant_id], client_id: params[:client_id]})
  end

  def edit; end

  def create_staff
    @model = User.new(user_params)

    # Assign Default Password and require it to be updated
    @model.password = SecureRandom.uuid
    @model.password_confirmation = @model.password

    if @model.save

      # Send a welcome email and instructions to reset the password

      redirect_to @model
    else
      render "new"
    end
  end

  def update
    if @model.update(user_params)
      redirect_to @model
    else
      render "edit"
    end
  end



  private
  def set_model
    @model = User.where(id: params[:id]).first if params[:id]
  end

  def user_params
    params.require(:user).permit(:first, :last, :email, :tenant_id, :client_id)
  end
end