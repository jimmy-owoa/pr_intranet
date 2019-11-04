class DailyInformationJob < ApplicationJob
  queue_as :daily_information

  def perform(*args)
    today = Date.today.strftime("%d/%m/%Y")
    santoral_today = IndicatorService.perform[:santoral]["hoy"]
    General::DailyInformation.create(value: santoral_today, info_type: "santoral", date: today)
  end
end
