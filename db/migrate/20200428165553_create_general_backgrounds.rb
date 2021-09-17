class CreateGeneralBackgrounds < ActiveRecord::Migration[5.2]
  def change
    create_table :general_backgrounds do |t|
      t.string :name
      t.date :starts
      t.date :ends

      t.timestamps
    end
  end
end
