class Booking < ApplicationRecord
  include ApplicationHelper

  belongs_to :tenant, optional: true
  belongs_to :booking_request
  belongs_to :client, optional: true
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id', optional: true
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  belongs_to :hotel

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }

  def title
    "Booking for #{requestor.full_name} on #{date_nice(booking_request.date_from)}"
  end

  def is_booked
    !confirmation_number.blank? && !rate.blank? && rate > 0
  end
  persistize :is_booked

  def tenant_id
    booking_request.try(:tenant_id)
  end
  persistize :tenant_id

  def requestor_id
    booking_request.try(:requestor_id)
  end
  persistize :requestor_id

  def assignee_id
    booking_request.try(:assignee_id)
  end
  persistize :assignee_id

  def client_id
    booking_request.try(:client_id)
  end
  persistize :client_id

  def total
    rate + tax
  end
  persistize :total


  def edit_path
    Rails.application.routes.url_helpers.edit_booking_path(self)
  end


  def show_map
    [
        ["total", "Total", Proc.new {|val| val}],
        ["tax", "Tax", Proc.new {|val| val}],
        ["hotel_id", "Hotel", Proc.new {|val| Hotel.find(val).try(:name)}],
        ["confirmation_number", "Confirmation #", Proc.new {|val| val}]
    ]
  end

  def denormalize
    self.is_booked_will_change!
    save
  end
end