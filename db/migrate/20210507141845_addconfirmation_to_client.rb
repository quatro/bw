class AddconfirmationToClient < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :confirmation_email, :string
  end
end
