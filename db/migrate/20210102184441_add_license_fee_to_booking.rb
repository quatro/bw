class AddLicenseFeeToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :license_fee, :decimal
    add_column :bookings, :annual_booking_number, :integer
  end
end
