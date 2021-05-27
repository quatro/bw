class BookingRequest < ApplicationRecord
  include ApplicationHelper
  include ActionView::Helpers::UrlHelper

  default_scope { order(date_from: :desc) }

  audited

  belongs_to :tenant
  belongs_to :client
  belongs_to :customer, optional: true
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id', optional: true
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  has_one :booking, dependent: :destroy
  has_many :booking_request_rooms, dependent: :destroy

  accepts_nested_attributes_for :booking_request_rooms, reject_if: :all_blank, allow_destroy: true

  scope :outstanding,    -> { joins("LEFT OUTER JOIN bookings on bookings.booking_request_id = booking_requests.id").where("bookings.id IS NULL AND (bookings.is_booked IS NULL OR bookings.is_booked = false)") }
  scope :outstanding_for_tenant, ->(tenant) { outstanding.where(tenant: tenant) }
  scope :unassigned, -> { where(assignee: nil) }
  # scope :foreman,

  validate :ensure_rooms_have_at_least_one_guest
  validate :ensure_guests_exist
  validate :ensure_requestor_full_name_present

  def nights
    date_to.to_date - date_from.to_date if date_from.present? && date_to.present?
  end
  persistize :nights

  def customer_id
    cust_id = self.attributes["customer_id"]
    new_name = self.attributes["new_customer_name"]
    id_cust = Customer.find_by_id(cust_id)
    name_cust = Customer.find_by_name(new_name)

    if id_cust.present?
      return id_cust.id

    elsif name_cust.present?
      return name_cust.id

    elsif new_name.present?
      new_cust = Customer.create({name: new_name, client_id: self.client_id})
      return new_cust.try(:id)

    else
      return nil

    end
  end
  persistize :customer_id

  def is_booked?
    booking.present? && booking.is_booked?
  end

  def geocode_address
    location_formatted
  end

  def name
    ["Request for", location_formatted, "on", dates_formatted, "by", requestor.try(:full_name)].join(" ")
  end

  def location_formatted
    [address, city, state].reject { |c| c.blank? }.join(', ')
  end

  def status
    return booking.status_name if booking.present?
    return "Outstanding"
  end

  def date_from_human
    date_human(date_from)
  end

  def date_and_nights
    [date_from_human, nights_formatted]. join(': ')
  end

  def nights_formatted
    [nights, "night(s)"].join(' ')
  end

  def dates_formatted
    [date_from, date_to].join(' - ')
  end

  def client_formatted
    client.try(:name)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_booking_request_path(self)
  end

  def requestor_id
    # If a name is provided we need to go based off this
    return assign_requestor_id_for_autocomplete_name(requestor_full_name) if !requestor_full_name.blank?

    # If no name is provided, then keep what was previously there
    return attributes[:requestor_id]
  end
  persistize :requestor_id

  def requestor_name
    requestor.present? ? requestor.try(:full_name) : attributes[:requestor_name]
  end
  persistize :requestor_name

  def rooms_formatted
    booking_request_rooms.each_with_index.map{|r, i| format_room(r, i+1)}.join("<br />")
  end
  persistize :rooms_formatted

  def show_map
    [
        ["location_formatted", "Location", Proc.new{|val| val}],
        ["date_and_nights", "Stay", Proc.new{|val| val}],
        # ["date_from", "From", Proc.new {|val| date_nice(val)}],
        # ["date_to", "To", Proc.new {|val| date_nice(val)}],
        # ["city", "City", Proc.new {|val| val}],
        # ["state", "State", Proc.new {|val| val}],
        ["reason", "Reason", Proc.new {|val| val}],
        ["job_identifier", "Job Identifier", Proc.new {|val| val}],
        ["customer_id", "Customer", Proc.new{|val| Customer.find_by_id(val).try(:name)}],
        ["booking_request_rooms", "Rooms", Proc.new {|val| val.each_with_index.map{|r, i| format_room(r, i+1)}.join("<br />")}],
        ["status", "Status", Proc.new {|val| val}],
        ["conflicts", "Conflicts", Proc.new {|val| val.map{|a| link_to(a.name, a.appropriate_link)}.join('<br />')}]
    ]
  end

  def appropriate_link
    return Rails.application.routes.url_helpers.edit_booking_path(booking) if booking.present?
    return Rails.application.routes.url_helpers.edit_booking_request_path(self)
  end

  def format_guests(room)
    "#{room.guests.map{|u| u.full_name}.join(', ')}"
  end

  def format_room(room, index)
    "Room #{index}: #{format_guests(room)}"
  end

  def each_day(&b)
    day = date_from

    while day < date_to
      b.call(day)
      day = day + 1
    end
  end

  def can_release
    return booking.nil?
  end

  def can_edit?
    true
  end

  def conflicts

    booking_request_rooms.flat_map{|brr| brr.guest_rooms}.map do |gr|
      GuestRoom.where("date = ? AND guest_id = ? AND id != ?", gr.date, gr.guest_id, gr.id)
    end.flatten.map{|gr| gr.booking_request_room.booking_request}.uniq

  end

  def self.conflicts
    query = "SELECT * FROM
    (
        select
        guest_rooms.date,
        guest_rooms.guest_id,
        count(guest_rooms.guest_id) as total,
        STRING_AGG(guest_rooms.id::character varying, ',') as ids
        FROM guest_rooms
        GROUP BY guest_rooms.date, guest_rooms.guest_id
    ) groups

    WHERE groups.total > 1"


    ids = ActiveRecord::Base.connection.execute(query).map do |row|
      row['ids'].split(',')
    end.flatten.compact


    BookingRequest.joins("
      LEFT OUTER JOIN booking_request_rooms on booking_request_rooms.booking_request_id = booking_requests.id
      LEFT OUTER JOIN guest_rooms on guest_rooms.booking_request_room_id = booking_request_rooms.id").where("guest_rooms.id IN (?)", ids).uniq

    # GuestRoom
    #     .includes({booking_request_room: [:booking_request]})
    #     .where(id: ids)
  end


  def denormalize
    self.requestor_name_will_change!
    save
  end

  def ensure_rooms_have_at_least_one_guest
    if booking_request_rooms.select{|brr| brr.guest1_name.blank?}.any?
      errors.add(:rooms, 'You must select a first guest for each room')
    end
  end

  def ensure_requestor_full_name_present
    if requestor_full_name.blank?
      errors.add(:requestor, 'must exist')
    end
  end

  def ensure_guests_exist
    booking_request_rooms.each do |brr|
      if !brr.guest1_name.blank? && !User.where(full_name: convert_autocomplete_name_to_full_name(brr.guest1_name)).any?
        errors.add(:rooms, 'Guest 1 name was not found, please enter in a valid name')
      end

      if !brr.guest2_name.blank? && !User.where(full_name: convert_autocomplete_name_to_full_name(brr.guest2_name)).any?
        errors.add(:rooms, 'Guest 2 name was not found, please enter in a valid name')
      end
    end
  end

  def convert_autocomplete_name_to_full_name(autocomplete_name)
    autocomplete_name.present? ? autocomplete_name.split(' / ')[0].strip : ''
  end

  def assign_requestor_id_for_autocomplete_name(name)
    if !name.blank?
      full_name = name.split('(')[0].strip
      return User.where(full_name: full_name).first.try(:id)
    end
  end
end