class CreateHelpcenterSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_subcategories do |t|
      t.string :name, default: ""
      t.string :slug
      t.references :category

      t.timestamps
    end
  end
end
