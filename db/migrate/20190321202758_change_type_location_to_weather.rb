class ChangeTypeLocationToWeather < ActiveRecord::Migration[5.2]
  def change
    change_column :general_weather_informations, :location, :integer
  end
end
