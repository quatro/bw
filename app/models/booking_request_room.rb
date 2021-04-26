class BookingRequestRoom < ApplicationRecord
  belongs_to :booking_request

  belongs_to :guest1, class_name:'User', foreign_key: 'guest1_id', optional: true
  belongs_to :guest2, class_name:'User', foreign_key: 'guest2_id', optional: true

  # validates :guest1, presence: true
  #

  def is_single
    room_size == 'Single'
  end

  def is_double
    room_size == 'Double'
  end

  def to_s
    guest_names
  end

  def guest_names
    guests.map{|u| u.full_name}.join(', ')
  end

  def guests
    [guest1, guest2].compact
  end

  def guest1_id
    assign_user_id_for_autocomplete_name(guest1_name)
  end
  persistize :guest1_id

  def guest2_id
    assign_user_id_for_autocomplete_name(guest2_name)
  end
  persistize :guest2_id

  def denormalize
    self.guest2_id_will_change!
    save
  end

  private
  def assign_user_id_for_full_name(name)
    if !name.blank?
      return User.where(full_name: name).first.try(:id)
    end
  end

  def assign_user_id_for_autocomplete_name(name)
    if !name.blank?
      full_name = name.split(' / ')[0].strip
      return User.where(full_name: full_name).first.try(:id)
    end
  end

end