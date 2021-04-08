class AddPrivateRate < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :private_rate, :decimal, precision: 8, scale: 2
  end
end
