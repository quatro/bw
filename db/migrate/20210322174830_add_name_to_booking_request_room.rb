class AddNameToBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_request_rooms, :guest1_name, :string
    add_column :booking_request_rooms, :guest2_name, :string
  end
end
