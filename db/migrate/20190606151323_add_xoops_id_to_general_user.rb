class AddXoopsIdToGeneralUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :xoops_id, :integer
    remove_column :general_users, :rut
  end
end
