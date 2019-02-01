class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      # SANTORAL: IndicatorService.perform[:santoral]['hoy'],
      # DOLAR:  IndicatorService.perform[:money]['dolar'],
      # EURO: IndicatorService.perform[:money]['euro'],
      # UF: IndicatorService.perform[:indicator]['uf'],
      # UTM: IndicatorService.perform[:indicator]['utm'],
      # IPC: IndicatorService.perform[:indicator]['ipc']
      SANTORAL: IndicatorService.perform[:santoral],
       DOLAR:  IndicatorService.perform[:dolar],
       EURO: IndicatorService.perform[:euro],
       UF: IndicatorService.perform[:uf],
       UTM: IndicatorService.perform[:utm],
       IPC: IndicatorService.perform[:ipc]
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

  # def faq
  #   data = []
  #   data << {
  #     question: 'Hola mundo',
  #     answer: 'Chao mundo'
  #   }
  #   respond_to do |format|
  #     format.json { render json: data }
  #     format.js
  #   end
  # end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

 end
