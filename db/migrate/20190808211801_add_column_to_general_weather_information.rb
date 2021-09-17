class AddColumnToGeneralWeatherInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :general_weather_informations, :uv_index, :integer
  end
end
