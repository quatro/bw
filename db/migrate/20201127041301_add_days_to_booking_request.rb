class AddDaysToBookingRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :nights, :integer
  end
end
