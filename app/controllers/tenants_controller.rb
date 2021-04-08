class TenantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_model

  def index; end
  def report; end
  def detail_report; end
  def run_detail_report
    from = DateTime.parse(params[:from]) if params[:from]
    to = DateTime.parse(params[:to]) if params[:to]

    models = Booking.for_tenant(current_user.active_tenant).completed.between_dates(from, to).order(:created_at)

    render partial:'bookings/report_detail', locals:{models: models}
  end

  def monthly_sales_data
    return monthly_data(:rate, 'rgba(60,141,188,0.9)', 'Sales')
  end

  def monthly_license_cost_data
    return monthly_data(:license_fee, '#ff6384', 'Usage Fees')
  end

  def monthly_data(prop, background_color, label)
    months_count = 12

    bookings_by_month = Booking.for_tenant(current_user.active_tenant).completed.last_months(months_count).order(:created_at).group_by { |a| a.booking_request.date_from.beginning_of_month }

    # Last months_count of months
    # months = months_count.times.map{|a| a.months.ago.strftime("%b %y")}.reverse
    months = bookings_by_month.map{|month, bookings| month.strftime("%b %y")}

    # byebug

    render json: {
        labels: months,
        datasets: [
            {
                label: label,
                backgroundColor: background_color,
                borderColor: 'rgba(60,141,188,0.8)',
                pointRadius: false,
                pointColor: '#3b8bba',
                pointStrokeColor: 'rgba(60,141,188,1)',
                pointHighlightFill: '#fff',
                pointHighlightStroke: 'rgba(60,141,188,1)',
                data: bookings_by_month.map{|month, bookings| bookings.sum{|a| a.send(prop)}}
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