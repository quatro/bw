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

  has_many :serviced_bookings, foreign_key: 'assignee_id', class_name:'Booking'
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
end
