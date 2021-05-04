class AddRequestorNameToBookingRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :requestor_full_name, :string
  end
end
