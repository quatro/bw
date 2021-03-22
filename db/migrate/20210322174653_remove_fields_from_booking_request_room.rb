class RemoveFieldsFromBookingRequestRoom < ActiveRecord::Migration[6.0]
  def change
    remove_column :booking_request_rooms, :guest1_first
    remove_column :booking_request_rooms, :guest1_last
    remove_column :booking_request_rooms, :guest2_first
    remove_column :booking_request_rooms, :guest2_last
  end
end
