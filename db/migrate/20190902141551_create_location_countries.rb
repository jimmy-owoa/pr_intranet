class CreateLocationCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :location_countries do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
