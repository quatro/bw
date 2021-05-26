
class GuestRoom < ApplicationRecord

  belongs_to :guest, class_name:'User', foreign_key: 'guest_id'
  belongs_to :booking_request_room

end