class AddMenuIdToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :general_menus, :post_id, :integer
  end
end
