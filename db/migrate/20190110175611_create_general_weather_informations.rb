class CreateGeneralWeatherInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :general_weather_informations do |t|
      t.string :location
      t.date :date
      t.string :max_temp
      t.string :min_temp
      t.string :current_temp
      t.string :condition
      t.string :icon

      t.timestamps
    end
  end
end
