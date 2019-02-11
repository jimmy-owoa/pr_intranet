class AddAttributesToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :legal_number, :string
    add_column :general_users, :legal_number_verification, :string
  end
end
