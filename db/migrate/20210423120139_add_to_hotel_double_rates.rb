class AddToHotelDoubleRates < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :double_rate, :decimal, precision: 8, scale: 2
    add_column :hotels, :double_private_rate, :decimal, precision: 8, scale: 2
  end
end
