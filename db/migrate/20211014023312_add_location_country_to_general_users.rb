class AddLocationCountryToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_users, :country
    remove_reference :general_users, :office
  end
end
