class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_foreman, :boolean
  end
end
