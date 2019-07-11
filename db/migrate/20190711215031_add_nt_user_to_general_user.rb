class AddNtUserToGeneralUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :nt_user, :string
  end
end
