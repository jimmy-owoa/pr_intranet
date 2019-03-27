class General::WeatherInformation < ApplicationRecord
  belongs_to :location, class_name: 'General::Location', foreign_key: :location_id
  def self.weather_cached
    Rails.cache.fetch('General::WeatherInformation.all', expires_in: 5.minute) { all.to_a }
  end
end
