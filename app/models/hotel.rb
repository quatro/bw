class Hotel < ApplicationRecord

  belongs_to :tenant
  has_many :bookings

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }

end