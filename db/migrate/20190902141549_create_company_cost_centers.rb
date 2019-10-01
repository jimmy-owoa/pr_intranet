class CreateCompanyCostCenters < ActiveRecord::Migration[5.2]
  def change
    create_table :company_cost_centers do |t|
      t.string :name

      t.timestamps
    end
  end
end
