class Frontend::WeatherInformationController < ApplicationController
  def weather
    @weather = General::WeatherInformation.weather_cached
    respond_to do |format|
      format.json { render json: @weather }
      format.js
    end
  end
end
