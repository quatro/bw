class BookingRoom < ApplicationRecord
  include ApplicationHelper

  belongs_to :tenant, optional: true
  belongs_to :booking
  belongs_to :client, optional: true
  belongs_to :booking_request_room

  validates_presence_of :confirmation_number, :rate

  KY_STATE_SALES_TAX = 0.06

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

  def internal_rate_plus_fee
    internal_rate.present? && fee.present? ? internal_rate + fee : 0
  end
  persistize :internal_rate_plus_fee

  def internal_tax
    !tax.blank? && !internal_rate.blank? && !rate.blank? ? (((rate - internal_rate) + fee) * KY_STATE_SALES_TAX) + tax : 0
  end
  persistize :internal_tax

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

  def calculate_totals

    # Make sure we have an internal rate stored
    # This wasn't being stored during launch and this helps provide a back fill
    self.update({internal_rate: booking_request_room.room_size == 'Double' ? booking.hotel.double_private_rate : booking.hotel.private_rate }) if internal_rate.blank?

    # Essentially the state will tax based on any margins we have, the margin is the internal rate minus the rate plus the billing fee
    self.update({internal_tax: (((rate - internal_rate) + fee) * KY_STATE_SALES_TAX) + tax }) if !internal_rate.blank? && !rate.blank? && !fee.blank? && !tax.blank?

    # Now update the totals correctly
    update({
      total: !rate.blank? && !tax.blank? ? rate + tax + client.billing_fee : 0,
      internal_total: !internal_rate.blank? && !internal_tax.blank? ? internal_rate + internal_tax + client.billing_fee : 0
    })
  end

  def self.calculate_totals
    BookingRoom.all.each{|a| a.calculate_totals}
  end
end