class CreateLocationRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :location_regions do |t|
      t.string :name
      t.string :code
      t.references :country

      t.timestamps
    end
  end
end
