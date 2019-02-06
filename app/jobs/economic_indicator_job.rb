class EconomicIndicatorJob < ApplicationJob
  queue_as :economic_indicator

  def perform(*args)

    today =  Date.today.strftime("%d/%m/%Y")
    dolar = IndicatorService.perform[:dolar]
    euro = IndicatorService.perform[:euro]
    uf = IndicatorService.perform[:uf]
    utm = IndicatorService.perform[:utm]
    ipc = IndicatorService.perform[:ipc]
    General::EconomicIndicator.create(date: today, economic_indicator_type_id: 1, value: dolar)
    General::EconomicIndicator.create(date: today, economic_indicator_type_id: 2, value: euro)
    General::EconomicIndicator.create(date: today, economic_indicator_type_id: 3, value: uf)
    General::EconomicIndicator.create(date: today, economic_indicator_type_id: 4, value: utm)
    General::EconomicIndicator.create(date: today, economic_indicator_type_id: 5, value: ipc)    
  end

end