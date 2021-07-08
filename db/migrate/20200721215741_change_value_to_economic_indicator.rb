class ChangeValueToEconomicIndicator < ActiveRecord::Migration[5.2]
  def change
    change_column :general_economic_indicators, :value, :string
  end
end
