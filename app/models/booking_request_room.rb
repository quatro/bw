class BookingRequestRoom < ApplicationRecord
  belongs_to :booking_request, optional: true

  belongs_to :guest1, class_name:'User', foreign_key: 'guest1_id'
  belongs_to :guest2, class_name:'User', foreign_key: 'guest2_id'

  validates :guest1, presence: true

  def guests
    [guest1, guest2].compact
  end

  def guest1
    name = self.attributes["guest1_name"]
    if name.present?
      firstAndLast = name.split(" ")
      first = firstAndLast[0]
      last = firstAndLast[1]
      
      if User.where(first: first).exists?(conditions = :none)
        user = User.where(first: first).where(last: last)
        return user
      else
        return nil
      end
    else
      return nil
    end  
  end

  def guest2
    name = self.attributes["guest2_name"]
    if name.present?
      firstAndLast = name.split(" ")
      first = firstAndLast[0]
      last = firstAndLast[1]
      
      if User.where(first: first).exists?(conditions = :none)
        user = User.where(first: first).where(last: last)
        return user
      else
        return nil
      end
    else
      return nil
    end  
  end

  # def guest1_id
  #   name = self.attributes["guest1_name"]

  #   byebug
  #   if name.present?
  #     firstAndLast = name.split(" ")
  #     first = firstAndLast[0]
  #     last = firstAndLast[1]
      
  #     if User.where(first: first).exists?(conditions = :none)
  #       user = User.where(first: first).where(last: last)
  #       if user != nil
  #         return user.id
  #       else
  #         return nil
  #       end
  #     else
  #       return nil
  #     end
  #   else
  #     return nil
  #   end  
  # end
  # persistize :guest1_id

  # def guest2_id
  #   name = self.attributes["guest2_name"]

  #   if name.present?
  #     firstAndLast = name.split(" ")
  #     first = firstAndLast[0]
  #     last = firstAndLast[1]
      
  #     if User.where(first: first).exists?(conditions = :none)
  #       user = User.where(first: first).where(last: last)
  #       if user != nil
  #         return user.id
  #       else
  #         return nil
  #       end
  #     else
  #       return nil
  #     end
  #   else
  #     return nil
  #   end  
  # end
  # persistize :guest2_id
end