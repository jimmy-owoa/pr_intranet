class AddReferrerToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :referrer, :string
  end
end
