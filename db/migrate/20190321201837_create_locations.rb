class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :general_locations do |t|
      t.string :name
      t.timestamps
    end

    add_column :general_weather_informations, :location_id, :integer

    if ActiveRecord::Base.connection.column_exists?(:general_weather_informations, :location)
      General::WeatherInformation.all.each do |l|
        case l.location
        when 'Antofagasta'
          l.update_attributes(location_id: 1)
        when 'Santiago'
          l.update_attributes(location_id: 2)
        when 'Copiapo'
          l.update_attributes(location_id: 3)
        when 'La Serena'
          l.update_attributes(location_id: 4)
        when 'Vina del Mar'
          l.update_attributes(location_id: 5)
        when 'Rancagua'
          l.update_attributes(location_id: 6)
        when 'Talca'
          l.update_attributes(location_id: 7)
        when 'Concepcion'
          l.update_attributes(location_id: 8)
        when 'Temuco'
          l.update_attributes(location_id: 9)
        when 'Puerto Montt'
          l.update_attributes(location_id: 10)
        end
      end
    end
    remove_column :general_weather_informations, :location
  end
end
