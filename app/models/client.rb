class Client < ApplicationRecord

  belongs_to :tenant
  has_many :booking_requests
  has_many :bookings
  has_many :users

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }


end