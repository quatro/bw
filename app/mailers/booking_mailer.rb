class BookingMailer < ActionMailer::Base

  def send_confirmation(booking)
    return if booking.tenant.try(:from_email).blank? || booking.requestor.try(:email).blank?

    mail from: booking.tenant.from_email, to: booking.requestor.email, subject: booking.confirmation_email_subject
  end

end


