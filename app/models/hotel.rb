class Hotel < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :tenant
  has_many :bookings

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }

  def lat
    geo.latitude
  end
  persistize :lat

  def lng
    geo.longitude
  end
  persistize :lng

  def name_with_rate
    [name, number_to_currency(rate)].join(' / ')
  end

  def geocode_address
    [[address, city].join(' '), state].join(', ')
  end

  def show_map
    [
        ["name", "Name", Proc.new {|val| val}],
        ["phone_number", "Phone Number", Proc.new {|val| val}],
        ["contract_start_date", "Contract Start Date", Proc.new {|val| val}],
        ["contract_end_date", "Contract End Date", Proc.new {|val| val}],
        ["address", "Address", Proc.new {|val| val}],
        ["city", "City", Proc.new {|val| val}],
        ["state", "State", Proc.new {|val| val}],
        ["zip", "Zip Code", Proc.new {|val| val}],
        ["rate", "Client Rate", Proc.new {|val| number_to_currency(val)}],
        ["private_rate", "Hotel LNR", Proc.new {|val| number_to_currency(val)}],
        ["notes", "Notes", Proc.new {|val| val}]
    ]
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_tenant_hotel_path(tenant, self)
  end

  def denormalize
    self.lat_will_change!
    save
  end

  private
  def geo
    @geo ||= Geocoder.new.geocode(geocode_address)
  end
end