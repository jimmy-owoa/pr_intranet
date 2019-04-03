class AddRutToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :rut, :string
  end
end
