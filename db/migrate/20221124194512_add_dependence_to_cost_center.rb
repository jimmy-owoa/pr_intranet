class AddDependenceToCostCenter < ActiveRecord::Migration[5.2]
  def change
    add_column :company_cost_centers, :dependence, :string
  end
end
