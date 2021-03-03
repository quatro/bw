class CreateCustomer < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.references :client
      t.timestamps
    end
  end
end
