class BookingRequestRoom < ApplicationRecord
  belongs_to :booking_request, optional: true

  belongs_to :guest1, class_name:'User', foreign_key: 'guest1_id'
  belongs_to :guest2, class_name:'User', foreign_key: 'guest2_id'

  validates :guest1, presence: true

  def guests
    [guest1, guest2].compact
  end

  def guest_1_full_name
    user = User.find_by_id(self.guest1_id)
    return user.full_name
  end

  def guest_2_full_name
    user = User.find_by_id(self.guest2_id)
    return user.full_name
  end
end