class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    today = Date.today.strftime("%d/%m/%Y")
    indicators = General::EconomicIndicator.where(date: today)
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      DOLAR: indicators[0].value,
      EURO: indicators[1].value,
      UF: indicators[2].value,
      UTM: indicators[3].value,
      IPC: indicators[4].value,
      LATEST_DOLAR: General::EconomicIndicator.where(economic_indicator_type_id: 1).map(&:value).last(5),
      LATEST_EURO: General::EconomicIndicator.where(economic_indicator_type_id: 2).map(&:value).last(5),
      LATEST_UF: General::EconomicIndicator.where(economic_indicator_type_id: 3).map(&:value).last(5),
      LATEST_IPC: General::EconomicIndicator.where(economic_indicator_type_id: 5).map(&:value).last(5),
      LATEST_UTM: General::EconomicIndicator.where(economic_indicator_type_id: 4).map(&:value).last(5)
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
