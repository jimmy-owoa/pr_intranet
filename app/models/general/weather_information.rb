class General::WeatherInformation < ApplicationRecord
  belongs_to :location, class_name: "General::Location", foreign_key: :location_id
  scope :current, ->(location_id) { where(date: Date.today, location_id: location_id) }
  scope :next, ->(location_id, day) { where(date: Date.today + day.days, location_id: location_id) }

  def self.weather_cached
    Rails.cache.fetch("General::WeatherInformation.all", expires_in: 5.minute) { all.to_a }
  end

  def as_json_with_today
    today = {
      day: I18n.l(Date.today, format: "%A"),
      day_icon: self.icon,
      current_temp: self.current_temp,
      min_temp: self.min_temp,
      max_temp: self.max_temp,
      uv_index: self.get_uv
    }
    today
  end

  def as_json_with_remaing_days
    remaing_days = []
    remaing_days << {
      day: I18n.l(Date.today + 1, format: "%A"),
      day_icon: self.tomorrow_icon,
      min_temp: self.tomorrow_min,
      max_temp: self.tomorrow_max
    }

    remaing_days << {
      day: I18n.l(Date.today + 2, format: "%A"),
      day_icon: self.after_tomorrow_icon,
      min_temp: self.after_tomorrow_min,
      max_temp: self.after_tomorrow_max
    }

    remaing_days << {
      day: I18n.l(Date.today + 3, format: "%A"),
      day_icon: self.aa_tomorrow_icon,
      min_temp: self.aa_tomorrow_min,
      max_temp: self.aa_tomorrow_max
    }

    remaing_days << {
      day: I18n.l(Date.today + 4, format: "%A"),
      day_icon: self.aaa_tomorrow_icon,
      min_temp: self.aaa_tomorrow_min,
      max_temp: self.aaa_tomorrow_max
    }

    remaing_days
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
