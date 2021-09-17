class CreateEconomicIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :general_economic_indicators do |t|
      t.date :date
      t.integer :economic_indicator_type_id
      t.string :value

      t.timestamps
    end
  end
end
