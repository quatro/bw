class Client < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :tenant
  has_many :booking_requests, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy

  scope :for_tenant,      ->(tenant) { where(tenant: tenant) }

  def booking_requestable_users
    users.is_foreman
  end

  def show_map
    [
        ["name", "Name", Proc.new {|val| val}],
        ["billing_fee", "Billing Fee", Proc.new {|val| number_to_currency(val)}],
        ["domain_name", "Domain", Proc.new {|val| val}],
        ["confirmation_email", "Confirmation Email", Proc.new {|val| val}]
    ]
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_tenant_client_path(tenant, self)
  end
end