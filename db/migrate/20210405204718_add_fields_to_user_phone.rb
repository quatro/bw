class AddFieldsToUserPhone < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :employee_id, :string
  end
end
