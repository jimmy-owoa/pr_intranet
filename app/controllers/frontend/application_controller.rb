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

  def weather
    data = []
    data << {
      HOY: l(Date.today, format: '%A %d %B %Y'),
      ANTOFAGASTA: WeatherService.perform[:antofagasta]['main'],
      SANTIAGO: WeatherService.perform[:santiago]['main'],
      CONCEPCION: WeatherService.perform[:concepcion]['main'],
      PUERTO_MONTT: WeatherService.perform[:puerto_montt]['main'],
      LA_SERENA: WeatherService.perform[:la_serena]['main'],
      VINA_DEL_MAR: WeatherService.perform[:vina_del_mar]['main'],
      TALCA: WeatherService.perform[:talca]['main'],
      COPIAPO: WeatherService.perform[:copiapo]['main'],
      TEMUCO: WeatherService.perform[:temuco]['main'],

    }
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

 end
