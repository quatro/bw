class BookingRequest < ApplicationRecord
  include ApplicationHelper

  default_scope { order(date_from: :desc) }

  audited

  belongs_to :tenant
  belongs_to :client
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  has_one :booking

  scope :outstanding,    -> { joins("LEFT OUTER JOIN bookings on bookings.booking_request_id = booking_requests.id").where("bookings.id IS NULL AND (bookings.is_booked IS NULL OR bookings.is_booked = false)") }
  scope :outstanding_for_tenant, ->(tenant) { outstanding.where(tenant: tenant) }
  scope :unassigned, -> { where(assignee: nil) }

  def nights
    date_to.to_date - date_from.to_date if date_from.present? && date_to.present?
  end
  persistize :nights

  def is_booked?
    booking.present? && booking.is_booked?
  end

  def geocode_address
    location_formatted
  end

  def name
    ["Request for", location_formatted, "on", dates_formatted, "by", requestor.full_name].join(" ")
  end

  def location_formatted
    [city, state].join(', ')
  end

  def date_from_human
    date_human(date_from)
  end

  def date_and_nights
    [date_from_human, nights_formatted]. join(': ')
  end

  def nights_formatted
    [nights, "night(s)"].join(' ')
  end

  def dates_formatted
    [date_from, date_to].join(' - ')
  end

  def client_formatted
    client.try(:name)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_booking_request_path(self)
  end

  def show_map
    [
        ["location_formatted", "Location", Proc.new{|val| val}],
        ["date_and_nights", "Stay", Proc.new{|val| val}],
        # ["date_from", "From", Proc.new {|val| date_nice(val)}],
        # ["date_to", "To", Proc.new {|val| date_nice(val)}],
        # ["city", "City", Proc.new {|val| val}],
        # ["state", "State", Proc.new {|val| val}],
        ["reason", "Reason", Proc.new {|val| val}],
        ["job_identifier", "Job Identifier", Proc.new {|val| val}],
    ]
  end
end