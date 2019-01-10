class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      SANTORAL: IndicatorService.perform[:santoral]['hoy'],
      DOLAR:  IndicatorService.perform[:money]['dolar'],
      EURO: IndicatorService.perform[:money]['euro'],
      UF: IndicatorService.perform[:indicator]['uf'],
      UTM: IndicatorService.perform[:indicator]['utm'],
      IPC: IndicatorService.perform[:indicator]['ipc']
    }
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end
872.000

  def weather
    data = []
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      # ANTOFAGASTA: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      SANTIAGO: { 
        forecast: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
        current: WeatherService.perform[:santiago]['current']
      },
      # CONCEPCION: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # PUERTO_MONTT: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # LA_SERENA: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # VINA_DEL_MAR: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # TALCA: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # COPIAPO: WeatherService.perform[:santiago]['forecast']['forecastday'][0],
      # TEMUCO: WeatherService.perform[:santiago]['forecast']['forecastday'][0],

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
