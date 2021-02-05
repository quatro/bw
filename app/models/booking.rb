class Booking < ApplicationRecord
  include ApplicationHelper

  belongs_to :tenant, optional: true
  belongs_to :booking_request
  belongs_to :client, optional: true
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id', optional: true
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  belongs_to :hotel
  belongs_to :cancelled_by_user, class_name: 'User', foreign_key: 'cancelled_by_user_id', optional: true

  scope :for_tenant,      ->(tenant) { where(tenant: tenant).order(:created_at) }
  scope :last_months,     ->(months_count) { where("created_at >= ?", months_count.months.ago)}
  scope :completed,       -> { where(is_cancelled: false, is_no_show: false)}
  scope :cancelled,       -> { where(is_cancelled: true, is_no_show: false)}
  scope :no_show,         -> { where(is_cancelled: false, is_no_show: true)}

  def title
    "Booking for #{requestor.full_name} on #{date_nice(booking_request.date_from)}"
  end

  # This method should be run nightly (for the current  year) to ensure all booking license data is updated properly
  # Chris Walker
  # 1/14/2021
  def self.assign_booking_numbers_for_year(year, tenant)
    date_from = Date.parse("#{year}-01-01")
    date_to = Date.parse("#{year.to_i+1}-01-01")

    license_fee_calculator = LicenseFeeCalculator.new

    total = 1
    Booking.for_tenant(tenant).completed.where("created_at >= ? AND created_at < ?", date_from.strftime("%Y-01-01"), date_to.strftime("%Y-01-01")).order(id: :asc).each do |b|
      b.update({
        annual_booking_number: total,
        license_fee_percentage: license_fee_calculator.percentage_rate(total)
      })

      b.reload

      b.update({
        license_fee: license_fee_calculator.calculate(b)
      })

      total += b.nights
    end
  end

  def nights
    booking_request.try(:nights)
  end

  # def annual_booking_number
  #   # created_at = DateTime.now if created_at.nil?
  #   # Booking.for_tenant(self.tenant).where("created_at >= ? AND created_at <= ? AND annual_booking_number IS NOT NULL", created_at.strftime("%Y-01-01"), created_at.strftime("%Y-12-31")).count + 1
  # end
  # persistize :annual_booking_number

  def license_fee_percentage
    license_fee_calculator.percentage_rate(annual_booking_number)
  end
  persistize :license_fee_percentage

  def license_fee
    license_fee_calculator.calculate(self)
  end
  persistize :license_fee

  def is_booked
    !confirmation_number.blank? && !rate.blank? && rate > 0
  end
  persistize :is_booked

  def tenant_id
    booking_request.try(:tenant_id)
  end
  persistize :tenant_id

  def requestor_id
    booking_request.try(:requestor_id)
  end
  persistize :requestor_id

  def assignee_id
    booking_request.try(:assignee_id)
  end
  persistize :assignee_id

  def client_id
    booking_request.try(:client_id)
  end
  persistize :client_id

  def total
    rate.present? && tax.present? ? rate + tax : 0
  end
  persistize :total


  def edit_path
    Rails.application.routes.url_helpers.edit_booking_path(self)
  end

  def cancel
    self.update({is_cancelled: true})
  end

  def no_show
    self.update({is_no_show: true})
  end


  def show_map
    vals = [
        ["total", "Total", Proc.new {|val| val}],
        ["tax", "Tax", Proc.new {|val| val}],
        ["hotel_id", "Hotel", Proc.new {|val| Hotel.find(val).try(:name)}],
        ["confirmation_number", "Confirmation #", Proc.new {|val| val}]
    ]

    # vals << ["is_cancelled", "Cancelled?", Proc.new{|val| "Yes"}] if is_cancelled

    vals
  end

  def can_cancel
    !is_cancelled && !is_no_show
  end

  def can_no_show
    !is_cancelled && !is_no_show
  end

  def denormalize
    self.is_booked_will_change!
    save
  end

  private
  def license_fee_calculator
    @license_fee_calculator ||= LicenseFeeCalculator.new
  end
end