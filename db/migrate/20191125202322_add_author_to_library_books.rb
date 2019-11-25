class AddAuthorToLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :library_books, :author
  end
end
