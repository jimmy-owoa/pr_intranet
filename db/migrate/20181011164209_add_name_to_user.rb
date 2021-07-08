class AddNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :name, :string
    add_column :general_users, :last_name, :string
    add_column :general_users, :last_name2, :string
    add_column :general_users, :active, :boolean, default: true
    add_column :general_users, :annexed, :string
    add_column :general_users, :birthday, :datetime
  end
end
