every 1.day, at: '05:00 am' do
  rake "daily:daily_information"
  rake "indicators:economic_indicator"
  rake "indicators:economic_indicator"
  rake "weather:weather_information"
end