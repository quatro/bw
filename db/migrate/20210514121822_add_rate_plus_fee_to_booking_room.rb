class AddRatePlusFeeToBookingRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_rooms, :rate_plus_fee, :decimal, precision: 8, scale: 2

    BookingRoom.all.each{|a| a.denormalize}
  end
end
