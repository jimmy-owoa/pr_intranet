class AddImageToLibraryBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :library_books, :image, :string
    add_column :library_books, :stock, :integer
    add_column :library_books, :rating, :integer
    add_column :library_books, :category, :string
  end
end
