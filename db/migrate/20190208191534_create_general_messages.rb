class CreateGeneralMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :general_messages do |t|
      t.string :title
      t.text :content
      t.integer :type
      t.boolean :is_const

      t.timestamps
    end
  end
end
