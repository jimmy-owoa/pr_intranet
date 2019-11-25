class CreateLibraryEditorials < ActiveRecord::Migration[5.2]
  def change
    create_table :library_editorials do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
