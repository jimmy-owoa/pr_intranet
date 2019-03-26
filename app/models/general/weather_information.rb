class General::WeatherInformation < ApplicationRecord
  has_one :location, class_name: 'General::Location'
  def self.weather_cached
    Rails.cache.fetch('General::WeatherInformation.all', expires_in: 5.minute) { all.to_a }
  end
end
