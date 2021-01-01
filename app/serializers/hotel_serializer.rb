class HotelSerializer < ActiveModel::Serializer

  attributes :id, :name, :address, :city, :state, :zip, :rate, :lat, :lng, :name_with_rate

end
