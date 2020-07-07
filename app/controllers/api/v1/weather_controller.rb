module Api::V1
  class WeatherController < ApiController
    def index
      user = @request_user
      location = user.location.present? ? General::Location.find(user.location_id).name : "No definido"
      weather = General::WeatherInformation.where(location_id: user.location_id).last

      data = []
      data << {
        location: location,
        today: weather.as_json_with_today,
        remaing_days: weather.as_json_with_remaing_days,
      }
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end
  end
end
