class CreateGeneralSections < ActiveRecord::Migration[5.2]
  def change
    create_table :general_sections do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.string :url

      t.timestamps
    end
  end
end
