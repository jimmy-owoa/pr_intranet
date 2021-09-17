class CreateIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :general_economic_indicator_types do |t|
      t.string :symbol
      t.string :name
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
