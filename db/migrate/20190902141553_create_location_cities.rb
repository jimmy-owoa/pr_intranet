class CreateLocationCities < ActiveRecord::Migration[5.2]
  def change
    create_table :location_cities do |t|
      t.string :name
      t.string :code
      t.references :region

      t.timestamps
    end
  end
end
