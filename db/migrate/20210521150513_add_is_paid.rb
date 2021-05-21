class AddIsPaid < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :is_paid, :boolean, default: false
    add_column :booking_rooms, :internal_rate, :decimal, precision:8, scale: 2
    add_column :booking_rooms, :internal_rate_plus_fee, :decimal, precision: 8, scale: 2
    add_column :booking_rooms, :internal_total, :decimal, precision:8, scale: 2
    add_column :bookings, :internal_total, :decimal, precision: 8, scale: 2
  end
end
