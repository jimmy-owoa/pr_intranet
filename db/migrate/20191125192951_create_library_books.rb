class CreateLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :library_books do |t|
      t.string :title
      t.integer :edition
      t.string :translation
      t.date :edition_date
      t.string :edition_place
      t.integer :publication_year
      t.string :isbn

      t.timestamps
    end
  end
end
