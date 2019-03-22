class ChangeNameWeatherInformation < ActiveRecord::Migration[5.2]
  def change
    rename_column :general_weather_informations, :location, :location_id
  end
end
