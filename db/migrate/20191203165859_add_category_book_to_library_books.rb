class AddCategoryBookToLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :library_books, :category_book
  end
end
