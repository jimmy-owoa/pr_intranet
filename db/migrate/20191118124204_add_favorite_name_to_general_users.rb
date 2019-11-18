class AddFavoriteNameToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :favorite_name, :string, default: ""
  end
end
