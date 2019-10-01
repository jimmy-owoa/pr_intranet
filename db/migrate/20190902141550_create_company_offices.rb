class CreateCompanyOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :company_offices do |t|
      t.string :address
      t.references :commune

      t.timestamps
    end
  end
end
