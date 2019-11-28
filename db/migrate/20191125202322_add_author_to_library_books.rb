class AddAuthorToLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :library_books, :author
    add_reference :library_books, :editorial
  end
end
