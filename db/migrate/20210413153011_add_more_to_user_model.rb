class AddMoreToUserModel < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :job_title, :string
    add_column :users, :employment_status, :string
    add_column :users, :cost_group, :string
    add_column :users, :cost_center, :string
    add_column :users, :termination_date, :date
    add_column :users, :modified_date, :date
  end
end
