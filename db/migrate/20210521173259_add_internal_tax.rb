class AddInternalTax < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_rooms, :internal_tax, :decimal, precision: 8, scale: 2
  end
end
