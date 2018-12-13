class Attachment < ActiveRecord::Migration[5.2]
  def change
    create_table :general_gallery_relations do |t|
      t.integer :gallery_id
      t.integer :attachment_id
      t.integer :position

      t.timestamps
    end

    add_index :general_gallery_relations, [:gallery_id, :attachment_id]


  end
end
