class TenantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end
  def report; end
  def monthly_sales_data
    months_count = 12

    bookings_by_month = Booking.for_tenant(current_user.active_tenant).last_months(months_count).order(:created_at).group_by { |a| a.created_at.beginning_of_month }

    # Last months_count of months
    months = months_count.times.map{|a| a.months.ago.strftime("%b %y")}.reverse

    render json: {
        labels: months,
        datasets: [
            {
                label: 'Sales',
                backgroundColor: 'rgba(60,141,188,0.9)',
                borderColor: 'rgba(60,141,188,0.8)',
                pointRadius: false,
                pointColor: '#3b8bba',
                pointStrokeColor: 'rgba(60,141,188,1)',
                pointHighlightFill: '#fff',
                pointHighlightStroke: 'rgba(60,141,188,1)',
                data: bookings_by_month.map{|month, bookings| bookings.sum{|a| a.total}}
            }
        ]
    }
  end

  def monthly_license_cost_data
    months_count = 12

    bookings_by_month = Booking.for_tenant(current_user.active_tenant).last_months(months_count).order(:created_at).group_by { |a| a.created_at.beginning_of_month }

    # Last months_count of months
    months = months_count.times.map{|a| a.months.ago.strftime("%b %y")}.reverse

    render json: {
        labels: months,
        datasets: [
            {
                label: 'License Fees',
                backgroundColor: '#ff6384',
                borderColor: 'rgba(60,141,188,0.8)',
                pointRadius: false,
                pointColor: '#3b8bba',
                pointStrokeColor: 'rgba(60,141,188,1)',
                pointHighlightFill: '#fff',
                pointHighlightStroke: 'rgba(60,141,188,1)',
                data: bookings_by_month.map{|month, bookings| bookings.sum{|a| a.license_fee}}
            }
        ]
    }
  end



  def hotel
    render json: Hotel.where(id: params[:hotel_id]).first
  end

  private
  def set_model
    @model = Tenant.where(id: params[:id]).first if params[:id]
  end
end