class BookingRoom < ApplicationRecord
  include ApplicationHelper

  belongs_to :tenant, optional: true
  belongs_to :booking
  belongs_to :client, optional: true
  belongs_to :booking_request_room

  validates_presence_of :confirmation_number

  def client_id
    booking.try(:client_id)
  end
  persistize :client_id

  def tenant_id
    booking.try(:tenant_id)
  end
  persistize :tenant_id


  def guest_names
    booking_request_room.try(:guests).map{|u| u.full_name}.join(', ')
  end

  def guests
    [booking_request_room.try(:guest1), booking_request_room.try(:guest2)].compact
  end

end