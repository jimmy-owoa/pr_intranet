class AddSupervisorToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :supervisor, :integer
  end
end
