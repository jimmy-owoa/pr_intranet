class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :general_menus do |t|
      t.string :title
      t.string :description
      t.string :css_class
      t.integer :code
      t.integer :priority
      t.integer :parent_id
      t.string :link

      t.timestamps
    end
  end
end
