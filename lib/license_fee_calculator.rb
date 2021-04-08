class LicenseFeeCalculator

  def calculate(booking)
    annual_booking_number = booking.annual_booking_number
    usage_fee_rate = percentage_rate(annual_booking_number)

    # Usage fee based off the rate of the hotel, does not include taxes
    return booking.rate * usage_fee_rate
  end

  def percentage_rate(annual_booking_number)
    return 0 if annual_booking_number.nil?

    if annual_booking_number < 10000
      return 0.1
    elsif annual_booking_number < 20000
      return 0.095
    elsif annual_booking_number < 30000
      return 0.090
    elsif annual_booking_number < 40000
      return 0.085
    elsif annual_booking_number < 50000
      return 0.078
    elsif annual_booking_number < 60000
      return 0.070
    elsif annual_booking_number < 70000
      return 0.060
    elsif annual_booking_number < 80000
      return 0.048
    else
      return 0.030
    end
  end
end