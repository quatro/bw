class ClientsController < ApplicationController
  include TenantScopedController
  load_and_authorize_resource
  before_action :set_model

  def upload_staff
    @upload_model = ClientStaffList.new
  end

  def do_upload_staff

    d = SimpleXlsxReader.open(params['user']['file'].open)
    hash = d.to_hash

    columns = [
        'Employee_Code',
        'FName',
        'LName',
        'Job_Title',
        'Phone',
        'Email_Address',
        'CLS Auth',
        'Employment_Status',
        'Cost_Group',
        'Cost_Center',
        'Termination_Date',
        'ModifiedDate'
    ]



    hash.each do |sheet_name,rows|
      rows.each_with_index do |row,i|
        if i == 0

          if columns.each_with_index.select{|c,i| row[i] != c}.any?
            raise 'Please upload a spreadsheet with the proper header formatting'
          end
        else

          employee_code = row[0]
          first_name = row[1]
          last_name = row[2]
          job_title = row[3]
          phone = row[4]
          email = row[5]
          is_foreman = row[6].try(:strip)
          employment_status = row[7]
          cost_group = row[8]
          cost_center = row[9]
          termination_date = row[10]
          modified_date = row[11]

          # Foremen must have an email address
          raise "Each foreman has to have an email address - #{first_name} / #{last_name}" if is_foreman == "Yes" && email.blank?

          # Make up an email
          if email.blank?
            email = "#{first_name.gsub(/\s+/, "")}.#{last_name.gsub(/\s+/, "")}@#{@model.domain_name}"
          end


          # See if we can find the user
          user = User.find_by_email(email)

          if user.nil?
            random_password = SecureRandom.uuid
            user = User.new
            user.email = email.try(:strip)
            user.first = first_name.try(:strip)
            user.last = last_name.try(:strip)
            user.password = random_password
            user.password_confirmation = random_password
            user.skip_confirmation!

          end

          user.update({
            first: first_name.try(:strip),
            last: last_name.try(:strip),
            client: @model,
            is_foreman: is_foreman == "Yes",
            employee_id: employee_code.try(:strip),
            phone: phone.try(:strip),
            job_title: job_title.try(:strip),
            employment_status: employment_status.try(:strip),
            cost_group: cost_group.try(:strip),
            cost_center: cost_center.try(:strip),
            termination_date: termination_date.try(:strip),
            modified_date: modified_date.try(:strip)
          })
        end
      end


    end

    return redirect_to tenant_client_path(@model.tenant, @model)
  end

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
    params.require(:client).permit(:name, :tenant_id, :billing_fee, :domain_name, :confirmation_email)
  end
end