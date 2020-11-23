class Tenant < ApplicationRecord

  has_many :booking_requests
  has_many :bookings
  has_many :users
  has_many :hotels

end