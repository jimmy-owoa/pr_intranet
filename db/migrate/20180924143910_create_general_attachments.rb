class CreateGeneralAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :general_attachments do |t|
      t.string :name
      t.string :path
      t.string :dimension
      t.boolean :is_public
      t.references :attachable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
