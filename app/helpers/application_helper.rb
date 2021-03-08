require 'carmen'

module ApplicationHelper
  include Carmen
  include ActionView::Helpers::NumberHelper

  def outstanding_booking_request_count(tenant)
    human_number(BookingRequest.outstanding_for_tenant(tenant).unassigned.count)
  end

  def no_show_booking_count(tenant)
    human_number(Booking.for_tenant(tenant).no_show.count)
  end

  def cancelled_booking_count(tenant)
    human_number(Booking.for_tenant(tenant).cancelled.count)
  end

  def completed_booking_count(tenant)
    human_number(Booking.for_tenant(tenant).completed.count)
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

  def date_human(date)
    unless date.nil?
      date.strftime("%A, %B %d")
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

  def human_number(val)
    number_to_human(val, format: '%n%u', units: { thousand: 'K', million: 'M' })
  end

  def form_submit_label(model)
    model.new_record? ? "Create" : "Update"
  end

  def method_for_model(model)
    model.new_record? ? :post : :put
  end

  def url_for_user_model(model)
    model.new_record? ? create_staff_users_path : user_path(model)
  end

  def customer_select_for_client(client)
    [[0, "--- New Customer ---"]].concat(Customer.where(client: client).map{|c| [c.id, c.name]})
  end

  def reason_select
    ['Regular', 'Storm']
  end

end
