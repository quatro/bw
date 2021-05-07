class AddPafSentToBooking < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :is_paf_sent, :boolean, default: false
  end
end
