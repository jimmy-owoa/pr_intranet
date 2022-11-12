class CreateGeneralCostCenterUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :general_cost_center_users do |t|
      t.float :percentage 
      t.references :user
      t.references :cost_center
      t.timestamps
    end
  end
end
