class AddLicenseFeePercentage < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :license_fee_percentage, :decimal, default: 0
  end
end
