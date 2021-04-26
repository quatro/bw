class AddSingleDoubleOption < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_request_rooms, :room_size, :string, default: 'Double'
  end
end
