class BookingRoom < ApplicationRecord
  include ApplicationHelper

  belongs_to :tenant, optional: true
  belongs_to :booking
  belongs_to :client, optional: true
  belongs_to :booking_request_room

  validates_presence_of :confirmation_number, :rate

  def client_id
    booking.try(:client_id)
  end
  persistize :client_id

  def tenant_id
    booking.try(:tenant_id)
  end
  persistize :tenant_id

  def rate_plus_fee
    rate.present? && fee.present? ? rate + fee : 0
  end
  persistize :rate_plus_fee

  def guest_names
    booking_request_room.try(:guests).map{|u| u.full_name}.join(', ')
  end

  def guests
    [booking_request_room.try(:guest1), booking_request_room.try(:guest2)].compact
  end


  def denormalize
    self.rate_plus_fee_will_change!
    save
  end
end