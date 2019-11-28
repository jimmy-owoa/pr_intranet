class CreateLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :library_books do |t|
      t.string :title, null: false
      t.text :description
      t.string :category
      t.integer :edition
      t.integer :publication_year
      t.integer :stock
      t.integer :rating

      t.timestamps
    end
  end
end
