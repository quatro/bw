class AddCustomerIdToBookingRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :customer_id, :integer
  end
end
