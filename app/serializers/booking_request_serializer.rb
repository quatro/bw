class BookingRequestSerializer < ActiveModel::Serializer

  attributes :id, :date_from, :date_to, :city, :state, :zip, :reason, :job_identifier, :created_at, :location_formatted, :nights, :nights_formatted, :date_from_formatted, :booking,

  def booking
    BookingSerializer.new(object.booking) if object.booking.present?
  end

  def date_from_formatted
    object.date_from.strftime("%b %d, %Y")
  end

  def nights_formatted
    name = object.nights == 1 ? "night" : "nights"
    [object.nights.to_s, name].join (' ')
  end

  def location_formatted
    [object.city, object.state].join(', ')
  end
end
