class AddUserIdToEmployeeBirths < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_births, :user_id, :integer
  end
end
