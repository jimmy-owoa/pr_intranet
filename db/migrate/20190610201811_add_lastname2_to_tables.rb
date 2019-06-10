class AddLastname2ToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :last_name2, :string
    add_column :employee_births, :child_lastname2, :string    
  end
end
