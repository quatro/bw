module ApplicationHelper

  def outstanding_booking_request_count(tenant)
    BookingRequest.outstanding_for_tenant(tenant).count
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

  def tenant_user_count(tenant)
    User.for_tenant(tenant).count
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
end
