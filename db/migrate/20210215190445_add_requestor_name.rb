class AddRequestorName < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :requestor_name, :string
  end
end
