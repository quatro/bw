class BookingRequest < ApplicationRecord

  audited

  belongs_to :tenant
  belongs_to :client
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  has_one :booking

  scope :outstanding,    -> { joins("LEFT OUTER JOIN bookings on bookings.booking_request_id = booking_requests.id").where("bookings.id IS NULL") }
  scope :outstanding_for_tenant, ->(tenant) { outstanding.where(tenant: tenant) }

  def location_formatted
    [city, state].join(', ')
  end

  def dates_formatted
    [date_from, date_to].join(' - ')
  end

  def client_formatted
    client.try(:name)
  end
end