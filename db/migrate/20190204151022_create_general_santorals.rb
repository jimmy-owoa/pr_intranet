class CreateGeneralSantorals < ActiveRecord::Migration[5.2]
  def change
    create_table :general_santorals do |t|
      t.string :names, array: true, default: [].to_yaml

      t.timestamps
    end
  end
end
