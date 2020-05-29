class General::EconomicIndicator < ApplicationRecord
  belongs_to :economic_indicator_type, class_name: "General::EconomicIndicatorType", optional: true

  scope :today, -> { where(date: Date.today) }

  def self.indicator_type(type)
    where(economic_indicator_type: type).map(&:value).last(7)
  end

  # def self.utm_indicator_type(utm)
  #   General::EconomicIndicator.where(economic_indicator_type: utm).map{|utm| [utm.value, utm.date] }.last(7)
  # end

  def self.as_json_today_indicators
    others_indicators = [
      { name: "Euro", values: self.indicator_type(2).last(2) },
      { name: "UF", values: self.indicator_type(3).last(2) },
      { name: "IPC", values: self.indicator_type(5).last(2) },
      { name: "IPSA", values: self.indicator_type(6).last(2) }
    ]

    indicators = []
    indicators << {
      today: "Hoy, #{I18n.l(Date.today, format: "%d de %B").downcase}",
      yesterday: "Ayer, #{I18n.l(Date.today - 1, format: "%d de %B").downcase}",
      last_month_1: I18n.l(Date.today - 1.month, format: "%B"),
      last_month_2: I18n.l(Date.today - 2.month, format: "%B"),
      dolar: self.indicator_type(1).last(2),
      others: others_indicators
    }

    indicators
  end

  def self.as_json_last_indicators
    others_indicators = [
      { name: "Euro", values: self.where(economic_indicator_type_id: 2).pluck(:value).last(2) },
      { name: "UF", values: self.where(economic_indicator_type_id: 3).pluck(:value).last(2) },
      { name: "IPC", values: self.where(economic_indicator_type_id: 5).pluck(:value).last(2) },
      { name: "IPSA", values: self.where(economic_indicator_type_id: 6).pluck(:value).last(2) }
    ]

    indicators = []
    indicators << {
      today: "Hoy, #{I18n.l(Date.today, format: "%d de %B").downcase}",
      yesterday: "Ayer, #{I18n.l(Date.today - 1, format: "%d de %B").downcase}",
      last_month_1: I18n.l(Date.today - 1.month, format: "%B"),
      last_month_2: I18n.l(Date.today - 2.month, format: "%B"),
      dolar: self.where(economic_indicator_type_id: 1).pluck(:value).last(2),
      others: others_indicators
    }

    indicators
  end
end
