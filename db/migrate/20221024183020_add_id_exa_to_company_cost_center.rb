class AddIdExaToCompanyCostCenter < ActiveRecord::Migration[5.2]
  def change
    add_column :company_cost_centers, :id_exa, :integer
  end
end
