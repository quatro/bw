class CreateBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_request_rooms do |t|
      t.integer :booking_request_id
      t.references :guest1
      t.references :guest2
    end
  end
end
