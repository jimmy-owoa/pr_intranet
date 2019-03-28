class EconomicIndicatorJob < ApplicationJob
  queue_as :economic_indicator

  def perform(*args)
    today =  Date.today
    data = IndicatorService.perform
    dolar = data[:dolar]
    euro = data[:euro]
    uf = data[:uf]
    utm = data[:utm]
    ipc = data[:ipc]
    ipsa = data[:ipsa]
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 1, value: dolar).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 2, value: euro).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 3, value: uf).first_or_create
    if General::EconomicIndicator.where(economic_indicator_type_id: 4).present?
      utm_last = General::EconomicIndicator.where(economic_indicator_type_id: 4).last
      General::EconomicIndicator.where(economic_indicator_type_id: 4).first_or_create if utm_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    else
      General::EconomicIndicator.where(date: today, economic_indicator_type_id: 4, value: utm).first_or_create
    end
    if General::EconomicIndicator.where(economic_indicator_type_id: 5).present?
      utm_last = General::EconomicIndicator.where(economic_indicator_type_id: 5).last
      General::EconomicIndicator.where(economic_indicator_type_id: 5).first_or_create if utm_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    else
      General::EconomicIndicator.where(date: today, economic_indicator_type_id: 5, value: utm).first_or_create
    end
    # General::EconomicIndicator.where(date: today, economic_indicator_type_id: 4, value: utm).first_or_create if utm_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    # General::EconomicIndicator.where(date: today, economic_indicator_type_id: 5, value: ipc).first_or_create if ipc_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 6, value: ipsa).first_or_create
  end

end