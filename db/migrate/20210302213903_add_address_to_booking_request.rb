class AddAddressToBookingRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :address, :string
  end
end
