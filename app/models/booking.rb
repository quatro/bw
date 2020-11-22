class Booking < ApplicationRecord

  belongs_to :tenant
  belongs_to :booking_request
  belongs_to :client
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'
  belongs_to :hotel

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }

end