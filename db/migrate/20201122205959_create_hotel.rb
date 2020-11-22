class CreateHotel < ActiveRecord::Migration[6.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip

      t.references :tenant

      t.timestamps
    end

    add_reference :bookings, :hotel
    add_reference :bookings, :assignee
    add_column :bookings, :rate, :decimal, precision: 8, scale: 2
    add_column :bookings, :tax, :decimal, precision: 8, scale: 2
    add_column :bookings, :total, :decimal, precision: 8, scale: 2
    add_column :hotels, :rate, :decimal, precision: 8, scale: 2
  end
end
