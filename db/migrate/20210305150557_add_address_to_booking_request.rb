class AddAddressToBookingRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :address, :string
    add_column :booking_requests, :new_customer_name, :string
  end
end
