class CreateLibraryBookEditorialRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :library_book_editorial_relationships do |t|
      t.integer :book_id
      t.integer :editorial_id

      t.timestamps
    end
  end
end
