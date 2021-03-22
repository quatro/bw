class AddFieldsToBookingRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_requests, :number_of_rooms, :integer
  end
end
