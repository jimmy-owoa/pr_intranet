class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    data << {
      HOY: Date.today.strftime("%d-%m-%Y"),
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

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def id_user
    data = []
    data << {
      hola: 'Hola' 
    }
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end
 end
