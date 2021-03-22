class AddTenantFromEmaiol < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :from_email, :string
  end
end
