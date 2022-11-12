class AddColumnSocietyToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_users, :society
  end
end
