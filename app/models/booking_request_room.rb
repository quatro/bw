class BookingRequestRoom < ApplicationRecord
  belongs_to :booking_request, optional: true

  belongs_to :guest1, class_name:'User', foreign_key: 'guest1_id'
  belongs_to :guest2, class_name:'User', foreign_key: 'guest2_id'

  validates :guest1, presence: true

  def guests
    [guest1, guest2].compact
  end

  def guest1_id
    byebug
    name = self.attributes["guest_1_name"]
    firstAndLast = name.split(" ")
    first = firstAndLast[0]
    last = firstAndLast[1]
    
    if User.where(first: first).exists?(conditions = :none)
      byebug
      user = User.where(first: first).where(last: last)
      if user != nil
        return user.id
      else
        return nil
      end
    else
      return nil
    end
  end
  persistize :guest1_id

  def guest2_id
    byebug
    name = self.attributes["guest_2_name"]
    firstAndLast = name.split(" ")
    first = firstAndLast[0]
    last = firstAndLast[1]
    
    if User.where(first: first).exists?(conditions = :none)
      user = User.where(first: first).where(last: last)
      if user != nil
        return user.id
      else
        return nil
      end
    else
      return nil
    end
  end
  persistize :guest2_id

  def guest_1_name
  end

  def guest_2_name
  end

end