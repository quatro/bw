class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable, :trackable

  belongs_to :tenant, optional: true
  belongs_to :client, optional: true

  has_many :assigned_booking_requests, foreign_key: 'assignee_id', class_name:'BookingRequest'
  has_many :requested_booking_requests, foreign_key: 'requestor_id', class_name:'BookingRequest'


  has_many :assigned_bookings, foreign_key: 'assignee_id', class_name:'Booking'
  has_many :requested_bookings, foreign_key: 'requestor_id', class_name:'Booking'

  scope :for_tenant, -> (tenant) { where(tenant: tenant) }

  def full_name
    [first, last].join(' ')
  end

  def is_tenant_based?
    tenant.present?
  end

  def is_client_based?
    client.present?
  end

  def is_super_user?
    email == 'ch.walker@gmail.com'
  end

  def active_tenant
    is_super_user? ? Tenant.first : tenant
  end

  def dashboard_header_name
    active_tenant.try(:name)
  end

  def show_map
    [
        ["first", "First Name", Proc.new {|val| val}],
        ["last", "Last Name", Proc.new {|val| val}],
        ["email", "Email", Proc.new {|val| val}],
        client.present? ? ["client_id", "Client", Proc.new {|val| Client.find(val).name}] : nil
    ].compact
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_tenant_hotel_path(tenant, self)
  end

  def can_create_booking_request?
    tenant.present?
  end
end
