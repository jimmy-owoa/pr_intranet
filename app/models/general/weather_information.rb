class General::WeatherInformation < ApplicationRecord
  belongs_to :location, class_name: "General::Location", foreign_key: :location_id
  scope :current, ->(location_id) { where(date: Date.today, location_id: location_id) }
  scope :next, ->(location_id, day) { where(date: Date.today + day.days, location_id: location_id) }

  def self.weather_cached
    Rails.cache.fetch("General::WeatherInformation.all", expires_in: 5.minute) { all.to_a }
  end

  def get_uv
    case self.uv_index
    when 0..2
      "bueno"
    when 3..5
      "moderado"
    when 6..7
      "alto"
    when 8..10
      "muy alto"
    when 11..20
      "extremadamente alto"
    end
  end
end
