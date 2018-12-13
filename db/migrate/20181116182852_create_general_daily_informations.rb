class CreateGeneralDailyInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :general_daily_informations do |t|
      t.text :value
      t.date :date
      t.string :info_type

      t.timestamps
    end
  end
end
