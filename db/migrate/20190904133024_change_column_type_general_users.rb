class ChangeColumnTypeGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :general_users, :company
    add_column :general_users, :company_id, :integer, default: 0
  end
end
