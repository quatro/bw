require 'carmen'

module ApplicationHelper
  include Carmen

  def outstanding_booking_request_count(tenant)
    BookingRequest.outstanding_for_tenant(tenant).unassigned.count
  end

  def completed_booking_count(tenant)
    Booking.for_tenant(tenant).count
  end

  def tenant_hotel_count(tenant)
    Hotel.for_tenant(tenant).count
  end

  def tenant_client_count(tenant)
    Client.for_tenant(tenant).count
  end

  def tenant_staff_count(tenant)
    User.for_tenant(tenant).count
  end

  def my_queue_count
    current_user.assigned_booking_requests.outstanding.count
  end

  def date_nice(date)
    unless date.nil?
      date.strftime("%Y-%m-%d")
    else
      ""
    end
  end

  def datetime_nice(date)
    unless date.nil?
      date.strftime("%Y-%m-%d %H:%M %p")
    else
      ""
    end
  end

  def alert_class_for_type(t)
    return "alert-info" if t == 'alert'
    return "alert-danger" if t == 'error'
    return "alert-success" if t == 'notice'
    return "alert-info"
  end

  def states
    us = Country.named('United States')
    us.subregions.map{|a| a.name}
  end
end
