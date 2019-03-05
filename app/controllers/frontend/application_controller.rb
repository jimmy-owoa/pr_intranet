class Frontend::ApplicationController < ApplicationController
  after_action :set_access_control_headers

  def index
  end

  def indicators
    data = []
    today = Date.today.strftime("%d/%m/%Y")
    indicator = General::EconomicIndicator
    indicators = indicator.where(date: today)
    if indicator.where(date: today).present?    
      data << {
        HOY: l(Date.today, format: '%A %d %B %Y'),
        DOLAR: indicator.indicator_type(1).last,
        EURO: indicator.indicator_type(2).last,
        UF: indicator.indicator_type(3).last,
        UTM: indicator.indicator_type(4).last,
        IPC: indicator.indicator_type(5).last,
        IPSA: indicator.indicator_type(6).last,
        LATEST_DOLAR: indicator.indicator_type(1),
        LATEST_EURO: indicator.indicator_type(2),
        LATEST_UF: indicator.indicator_type(3),
        LATEST_IPC: indicator.indicator_type(5),
        LATEST_UTM: indicator.indicator_type(4),
        LATEST_IPSA: indicator.indicator_type(6)
      }
    else
      data << {
        HOY: l(Date.today, format: '%A %d %B %Y'),
        DOLAR: indicator.where(economic_indicator_type_id: 1).last.value,
        EURO: indicator.where(economic_indicator_type_id: 2).last.value,
        UF: indicator.where(economic_indicator_type_id: 3).last.value,
        UTM: indicator.where(economic_indicator_type_id: 4).last.value,
        IPC: indicator.where(economic_indicator_type_id: 5).last.value,
        IPSA: indicator.where(economic_indicator_type_id: 6).last.value,
        LATEST_DOLAR: indicator.indicator_type(1),
        LATEST_EURO: indicator.indicator_type(2),
        LATEST_UF: indicator.indicator_type(3),
        LATEST_IPC: indicator.indicator_type(5),
        LATEST_UTM: indicator.indicator_type(4),
        LATEST_iPSA: indicator.indicator_type(6)
      }
    end
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

 end
