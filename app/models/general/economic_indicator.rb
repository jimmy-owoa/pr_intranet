class General::EconomicIndicator < ApplicationRecord
  belongs_to :economic_indicator_type,  class_name: 'General::EconomicIndicatorType', optional: true

  def self.indicator_type(type)
    where(economic_indicator_type: type).map(&:value).last(7)
  end
    
end
