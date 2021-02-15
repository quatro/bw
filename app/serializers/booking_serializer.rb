class BookingSerializer < ActiveModel::Serializer

  attributes :id, :confirmation_number, :rate, :tax, :total, :created_at, :hotel, :is_booked, :is_cancelled, :is_no_show

  def hotel
    HotelSerializer.new(object.hotel) if object.hotel.present?
  end
end
