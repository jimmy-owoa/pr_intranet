class CreateHelpcenterCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_categories do |t|
      t.string :name, default: ""
      t.string :slug
      t.references :profile
      
      t.timestamps
    end
  end
end
