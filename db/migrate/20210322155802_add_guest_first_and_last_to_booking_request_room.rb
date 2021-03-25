class AddGuestFirstAndLastToBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_request_rooms, :guest1_first, :string
    add_column :booking_request_rooms, :guest1_last, :string
    add_column :booking_request_rooms, :guest2_first, :string
    add_column :booking_request_rooms, :guest2_last, :string
  end
end
