class ChangeColumnGeneralEconomicIndicator < ActiveRecord::Migration[5.2]
  def change
    remove_column :general_economic_indicators, :value
    add_column :general_economic_indicators, :value, :float
  end
end
