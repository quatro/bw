class BookingRequestRoom < ApplicationRecord
    belongs_to :booking_request
    validates :guest1_id, presence: true
end