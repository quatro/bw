class CreateBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_request_rooms do |t|
      t.integer :booking_request_id
      t.integer :guest1_id
      t.integer :gues2_id
    end
  end
end
