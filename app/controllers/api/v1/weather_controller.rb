module Api::V1
  class WeatherController < FrontendController
    def index
      params[:id].present? ? id = params[:id] : id = General::User.first.id
      data = []
      user = General::User.find(id)
      location = user.location.present? ? General::Location.find(user.location_id).name : "No definido"
      weather = General::WeatherInformation.where(location_id: user.location_id).last
      data << {
        location: location,
        weather: weather,
        today: Date.today.strftime("%d/%m/%Y"),
        tomorrow: l(Date.today + 1, format: "%A"),
        tomorrow_1: l(Date.today + 2, format: "%A"),
        tomorrow_2: l(Date.today + 3, format: "%A"),
        tomorrow_3: l(Date.today + 4, format: "%A"),
      }
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end
  end
end
