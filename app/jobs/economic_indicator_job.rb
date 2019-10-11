class EconomicIndicatorJob < ApplicationJob
  queue_as :economic_indicator

  def perform(*args)
    today = Date.today
    data = IndicatorService.perform
    dolar = data[:dolar]
    euro = data[:euro]
    uf = data[:uf]
    utm = data[:utm]
    ipc = data[:ipc]
    ipsa = data[:ipsa]
    ipsa_variation = data[:ipsa_variation]
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 1, value: dolar).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 2, value: euro).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 3, value: uf).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 4, value: utm).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 5, value: ipc).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 6, value: ipsa).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 7, value: ipsa_variation).first_or_create
  end
end
