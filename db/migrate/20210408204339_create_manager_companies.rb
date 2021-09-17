class CreateManagerCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :general_manager_companies do |t|
      t.integer :manager_id
      t.integer :company_id

      t.timestamps
    end
  end
end
