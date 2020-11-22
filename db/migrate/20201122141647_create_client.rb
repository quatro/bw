class CreateClient < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references :tenant
      t.string :name
      t.timestamps
    end

    add_reference :bookings, :client
    add_reference :booking_requests, :client
    add_reference :users, :client
  end
end
