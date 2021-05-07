class BookingMailer < ActionMailer::Base

  def send_confirmation(booking)
    @model = booking
    return if booking.tenant.try(:from_email).blank? || booking.requestor.try(:email).blank?

    # Send to the person requesting the hotel
    mail from: booking.tenant.from_email, cc: booking.client.try(:confirmation_email), to: booking.requestor.email, subject: booking.confirmation_email_subject
  end

end


