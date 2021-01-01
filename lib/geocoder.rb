class Geocoder

  def geocode(address)
    geocodes = Google::Maps.geocode(address)
    return geocodes.first

    # geocodes.first.address = "Science Park, 1012 WX Amsterdam, Nederland"
    # geocodes.first.latitude = 52.3545543
    # geocodes.first.longitude = 4.9540916
  end
end