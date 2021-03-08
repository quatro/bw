class CreateBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_request_rooms do |t|
      t.integer :booking_request_id
      t.reference :guest1
      t.reference :guest2
    end
  end
end
