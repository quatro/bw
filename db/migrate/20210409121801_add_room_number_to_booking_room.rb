class AddRoomNumberToBookingRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_rooms, :room_number, :string
  end
end
