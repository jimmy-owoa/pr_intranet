class AddExaIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :id_exa, :integer
  end
end