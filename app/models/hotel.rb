class Hotel < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :tenant
  has_many :bookings

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }


  def show_map
    [
        ["name", "Name", Proc.new {|val| val}],
        ["address", "Address", Proc.new {|val| val}],
        ["city", "City", Proc.new {|val| val}],
        ["state", "State", Proc.new {|val| val}],
        ["zip", "Zip Code", Proc.new {|val| val}],
        ["rate", "Rate", Proc.new {|val| number_to_currency(val)}],
    ]
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_tenant_hotel_path(tenant, self)
  end
end