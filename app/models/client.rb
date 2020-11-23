class Client < ApplicationRecord

  belongs_to :tenant
  has_many :booking_requests
  has_many :bookings
  has_many :users

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }


  def show_map
    [
        ["name", "Name", Proc.new {|val| val}]
    ]
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_tenant_client_path(tenant, self)
  end
end