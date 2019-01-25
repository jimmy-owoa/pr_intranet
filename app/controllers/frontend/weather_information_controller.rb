class Frontend::WeatherInformationController < ApplicationController
  def weather
    @weather = General::WeatherInformation.all
    respond_to do |format|
      format.json { render json: @weather }
      format.js
    end
  end
end
