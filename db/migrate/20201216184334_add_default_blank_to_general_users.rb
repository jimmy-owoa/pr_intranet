class AddDefaultBlankToGeneralUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :general_users, :last_name2, from: nil, to: ""
  end
end
