class CreateGeneralSantorals < ActiveRecord::Migration[5.2]
  def change
    create_table :general_santorals do |t|
      t.string :name

      t.timestamps
    end
  end
end
