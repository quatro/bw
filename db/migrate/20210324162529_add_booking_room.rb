class AddBookingRoom < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_rooms do |t|
      t.references :booking
      t.references :booking_request_room
      t.string :confirmation_number
      t.references :tenant
      t.references :client

      t.timestamps
    end
  end
end
