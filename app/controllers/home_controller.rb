class HomeController < ApplicationController
  before_action {|c| c.require_authorization :home}

  def index; end
  def dashboard
    @outstanding_booking_request_count = BookingRequest.outstanding_for_tenant(current_user.active_tenant).count
  end
end