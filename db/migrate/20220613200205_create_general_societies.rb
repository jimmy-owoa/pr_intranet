class CreateGeneralSocieties < ActiveRecord::Migration[5.2]
  def change
    create_table :general_societies do |t|
      t.string :name
      t.string :country
      t.integer :id_exa

      t.timestamps
    end
  end
end
