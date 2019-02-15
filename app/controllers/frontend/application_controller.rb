class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    today = Date.today
    indicators = General::EconomicIndicator.where(date: today)
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      DOLAR: indicators[0].value,
      EURO: indicators[1].value,
      UF: indicators[2].value,
      UTM: indicators[3].value,
      IPC: indicators[4].value,
      IPSA: indicators[5].value,
      LATEST_DOLAR: General::EconomicIndicator.indicator_type(1),
      LATEST_EURO: General::EconomicIndicator.indicator_type(2),
      LATEST_UF: General::EconomicIndicator.indicator_type(3),
      LATEST_IPC: General::EconomicIndicator.indicator_type(5),
      LATEST_UTM: General::EconomicIndicator.indicator_type(4),
      LATEST_IPSA: General::EconomicIndicator.indicator_type(6)
    }
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end

  def weather
    data = []
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      # ANTOFAGASTA: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      SANTIAGO: { 
        icon: WeatherService.perform[:santiago]['hourly']['icon'],
        current: WeatherService.perform[:santiago]['currently']['temperature'],
        hourly_data: WeatherService.perform[:santiago]['hourly']['data'],
        day: WeatherService.perform[:santiago]['daily']['data'][0]
      }
    }
    respond_to do |format|
      format.json { render json: data[0] }
      format.js
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

 end
