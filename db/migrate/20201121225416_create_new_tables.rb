class CreateNewTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.timestamps
    end

    create_table :booking_requests do |t|
      t.references :tenant
      t.references :requestor
      t.references :assignee
      t.date :date_from
      t.date :date_to
      t.string :reason
      t.string :city
      t.string :state
      t.string :zip
      t.string :job_identifier
      t.timestamps
    end

    create_table :bookings do |t|
      t.references :tenant
      t.references :booking_request
      t.references :requestor
      t.string :confirmation_number

      t.timestamps
    end


    add_reference :users, :tenant
  end
end
