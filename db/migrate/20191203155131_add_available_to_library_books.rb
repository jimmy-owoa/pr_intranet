class AddAvailableToLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :library_books, :available, :boolean, default: false
    remove_column :library_books, :category
  end
end
