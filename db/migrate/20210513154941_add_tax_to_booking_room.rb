class AddTaxToBookingRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :rooms_formatted, :string
    add_column :booking_rooms, :tax, :decimal, precision: 6, scale: 2
    add_column :booking_rooms, :total, :decimal, precision: 8, scale: 2
    add_column :booking_rooms, :fee, :decimal, precision: 6, scale: 2
    add_column :booking_rooms, :is_folio_received, :boolean, default: false
    add_column :bookings, :is_folio_received, :boolean, default: false
    add_column :bookings, :is_invoiced, :boolean, default: false
    add_column :bookings, :status_name, :string, default: "Booked"
    add_column :bookings, :rooms_formatted, :string

    # BookingRequestRoom.all.each{|a| a.try(:denormalize)}
    # BookingRequest.all.each{|a| a.try(:denormalize)}
    # BookingRoom.all.each{|a| a.try(:denormalize)}
    # Booking.all.each{|a| a.try(:denormalize)}
  end
end
