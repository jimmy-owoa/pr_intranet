class General::EconomicIndicatorType < ApplicationRecord
  has_many :economic_indicators, class_name: 'General::EconomicIndicator', foreign_key: :economic_indicator_type_id
end
