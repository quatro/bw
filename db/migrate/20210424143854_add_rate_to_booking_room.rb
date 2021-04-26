class AddRateToBookingRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_rooms, :rate, :decimal, precision: 8, scale: 2
    remove_column :bookings, :rate, :decimal, precision: 8, scale: 2
    add_column :bookings, :rate_total, :decimal, precision: 8, scale: 2
  end
end
