class AddIsBooked < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :is_booked, :boolean, default: false
  end
end
