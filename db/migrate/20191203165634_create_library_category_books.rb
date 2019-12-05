class CreateLibraryCategoryBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :library_category_books do |t|
      t.string :name

      t.timestamps
    end
  end
end
