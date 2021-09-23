class AddAttributesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :user_code, :string
    add_column :general_users, :id_exa_boss, :integer
  end
end
