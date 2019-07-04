class AddIsPublicToEmployeeBirths < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_births, :is_public, :boolean
  end
end
