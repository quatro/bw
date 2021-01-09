class MakeConfirmationNumberEmptyStringByDefault < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :confirmation_number, :string, default: ""
  end
end
