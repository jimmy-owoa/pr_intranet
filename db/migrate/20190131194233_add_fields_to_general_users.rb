class AddFieldsToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :company, :string
    add_column :general_users, :position, :string
  end
end
