class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_model
  before_action :force_json, only: :autocomplete

  def index
    @models = User.for_tenant(current_user.active_tenant)
  end

  def autocomplete
    @client = Client.where(id: params[:client_id]) if params[:client_id]
    @models = Searchers::UserSearcher.new.search(User.for_client(@client), params[:query])
    @results = @models.map { |u| {value: u.full_name, data: u.full_name}}
    @suggestions = { suggestions: @results }
    render json: @suggestions
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

    render partial: 'requestors_list', locals:{users: client.try(:booking_requestable_users).sort_by{|u| u.full_name}}
  end

  def new_staff
    @model = User.new({tenant_id: current_user.active_tenant.try(:id)})
  end

  def new_client_user
    @model = User.new({client_id: params[:client_id]})
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

  def force_json
    request.format = :json
  end

  def user_params
    params.require(:user).permit(:first, :last, :email, :tenant_id, :client_id, :is_foreman, :phone, :employee_id, :job_title, :employment_status, :cost_group, :cost_center, :termination_date, :modified_date)
  end
end