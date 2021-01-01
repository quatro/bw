class AddLatLonToHotel < ActiveRecord::Migration[6.0]
  def change
    add_column :hotels, :lat, :string
    add_column :hotels, :lng, :string
  end
end
