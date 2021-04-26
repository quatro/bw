class AddClientFee < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :billing_fee, :decimal, precision: 8, scale: 2
    add_column :clients, :domain, :string
    add_column :hotels, :notes, :text
  end
end
