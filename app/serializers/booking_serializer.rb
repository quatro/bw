class BookingSerializer < ActiveModel::Serializer

  attributes :id, :confirmation_number, :rate, :tax, :total, :created_at, :hotel, :is_booked

  def hotel
    HotelSerializer.new(object.hotel) if object.hotel.present?
  end
end
