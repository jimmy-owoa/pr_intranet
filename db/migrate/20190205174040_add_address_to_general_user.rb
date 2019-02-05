class AddAddressToGeneralUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :address, :string
  end
end
