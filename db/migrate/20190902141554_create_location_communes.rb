class CreateLocationCommunes < ActiveRecord::Migration[5.2]
  def change
    create_table :location_communes do |t|
      t.string :name
      t.string :code
      t.references :city

      t.timestamps
    end
  end
end
