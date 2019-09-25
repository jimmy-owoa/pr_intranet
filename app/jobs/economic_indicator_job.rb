class EconomicIndicatorJob < ApplicationJob
  queue_as :economic_indicator

  def perform(*args)
    today = Date.today
    data = IndicatorService.perform
    dolar = data[:dolar].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    euro = data[:euro].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    uf = data[:uf].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    utm = data[:utm].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    ipc = data[:ipc].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    ipsa = data[:ipsa].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    ipsa_variation = data[:ipsa_variation].to_s.gsub(/[.,]/, '.' => ',', ',' => '.')
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 1, value: dolar).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 2, value: euro).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 3, value: uf).first_or_create
    if General::EconomicIndicator.where(economic_indicator_type_id: 4).present?
      utm_last = General::EconomicIndicator.where(economic_indicator_type_id: 4).last
      General::EconomicIndicator.where(economic_indicator_type_id: 4, value: utm).first_or_create if utm_last.date.strftime("%m/%Y") != today.strftime("%m/%Y")
    else
      General::EconomicIndicator.where(date: today, economic_indicator_type_id: 4, value: utm).first_or_create
    end
    if General::EconomicIndicator.where(economic_indicator_type_id: 5).present?
      ipc_last = General::EconomicIndicator.where(economic_indicator_type_id: 5).last
      General::EconomicIndicator.where(economic_indicator_type_id: 5, value: ipc).first_or_create if ipc_last.date.strftime("%m/%Y") != today.strftime("%m/%Y")
    else
      General::EconomicIndicator.where(date: today, economic_indicator_type_id: 5, value: ipc).first_or_create
    end
    # General::EconomicIndicator.where(date: today, economic_indicator_type_id: 4, value: utm).first_or_create if utm_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    # General::EconomicIndicator.where(date: today, economic_indicator_type_id: 5, value: ipc).first_or_create if ipc_last.date.strftime('%m/%Y') != today.strftime('%m/%Y')
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 6, value: ipsa).first_or_create
    General::EconomicIndicator.where(date: today, economic_indicator_type_id: 7, value: ipsa_variation).first_or_create
  end
end
