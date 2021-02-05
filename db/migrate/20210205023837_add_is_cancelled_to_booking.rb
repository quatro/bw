class AddIsCancelledToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :is_cancelled, :boolean, default: false
    add_column :bookings, :is_no_show, :boolean, default: false
    add_reference :bookings, :cancelled_by_user
  end
end
