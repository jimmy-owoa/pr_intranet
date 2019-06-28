class CreateGeneralFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :general_files do |t|
      t.string :name
      t.integer :post_id
      
      t.timestamps
    end
  end
end
