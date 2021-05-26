class AddGuestManifest < ActiveRecord::Migration[6.1]
  def change
    create_table :guest_rooms do |t|
      t.references :guest
      t.references :booking_request_room
      t.date :date
      t.timestamps

    end

    BookingRequestRoom.all.each{|a| a.update_guest_rooms}
  end
end
