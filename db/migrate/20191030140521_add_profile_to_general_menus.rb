class AddProfileToGeneralMenus < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_menus, :profile
  end
end
