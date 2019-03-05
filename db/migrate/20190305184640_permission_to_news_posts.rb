class PermissionToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :general_terms, :permission, :string
  end
end
