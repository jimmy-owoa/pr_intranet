class General::WeatherInformation < ApplicationRecord
  belongs_to :location, class_name: 'General::Location'
  scope :current, -> (location_id) { where(date: Date.today, location_id: location_id) }
  
  def self.weather_cached
    Rails.cache.fetch('General::WeatherInformation.all', expires_in: 5.minute) { all.to_a }
  end

end
