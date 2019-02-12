every 1.day, at: '05:00 am' do
  rake "daily:daily_information"
  rake "indicators:economic_indicator"
  rake "products:products_expiration"
end

every :hour do 
  rake "weather:weather_information"
end