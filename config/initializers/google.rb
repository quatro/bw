Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::API_KEY
  config.api_key = ENV.fetch('GOOGLE_MAPS_API_KEY')
end