class AddAuthTokenToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :auth_token, :string
  end
end
