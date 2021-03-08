class BookingRequestRoom < ApplicationRecord
    belongs_to :booking_request
    validates :guest1_id, :prescense => true
end