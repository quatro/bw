class Tenant < ApplicationRecord

  has_many :booking_requests
  has_many :bookings
  has_many :users
  has_many :hotels
  has_many :clients

  # def active_client
  #   is_super_user? ? Client.first : client
  # end
end