class BookingRequestRoom < ApplicationRecord
  belongs_to :booking_request, optional: true

  belongs_to :guest1, class_name:'User', foreign_key: 'guest1_id'
  belongs_to :guest2, class_name:'User', foreign_key: 'guest2_id'

  validates :guest1, presence: true

  def guests
    [guest1, guest2].compact
  end
end