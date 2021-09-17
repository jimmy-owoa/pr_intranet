class CreateNewsMeta < ActiveRecord::Migration[5.2]
  def change
    create_table :news_meta do |t|
      t.string :object_type
      t.integer :object_id
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
