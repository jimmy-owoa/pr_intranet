class AddDataToWeather < ActiveRecord::Migration[5.2]
  def change
    #tomorrow
    add_column :general_weather_informations, :tomorrow_icon, :string
    add_column :general_weather_informations, :tomorrow_max, :string
    add_column :general_weather_informations, :tomorrow_min, :string
    #tomorrow 1
    add_column :general_weather_informations, :after_tomorrow_icon, :string
    add_column :general_weather_informations, :after_tomorrow_max, :string
    add_column :general_weather_informations, :after_tomorrow_min, :string
    #tomorrow 2
    add_column :general_weather_informations, :aa_tomorrow_icon, :string
    add_column :general_weather_informations, :aa_tomorrow_max, :string
    add_column :general_weather_informations, :aa_tomorrow_min, :string
    #tomorrow 3
    add_column :general_weather_informations, :aaa_tomorrow_icon, :string
    add_column :general_weather_informations, :aaa_tomorrow_max, :string
    add_column :general_weather_informations, :aaa_tomorrow_min, :string
  end
end
