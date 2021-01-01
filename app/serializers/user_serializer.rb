class UserSerializer < ActiveModel::Serializer

  attributes :first, :last, :email, :requested_booking_requests, :client

  def requested_booking_requests
    object.requested_booking_requests.map{|a| BookingRequestSerializer.new(a) }
  end

  def client
    object.client
  end
end
