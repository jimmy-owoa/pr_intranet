class RemoveIsbnFromLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :library_books, :isbn, :string
    remove_column :library_books, :edition_place, :string
    remove_column :library_books, :translation, :string
  end
end
