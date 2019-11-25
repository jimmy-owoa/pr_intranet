class CreateJoinTableBookEditorial < ActiveRecord::Migration[5.2]
  def change
    create_join_table :library_books, :library_editorials do |t|
      # t.index [:library_book_id, :library_editorial_id]
      # t.index [:library_editorial_id, :library_book_id]
    end
  end
end
