class AddShowBirthdayToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :show_birthday, :boolean, default: true
  end
end
