class CreateCompanyManagements < ActiveRecord::Migration[5.2]
  def change
    create_table :company_managements do |t|
      t.string :name

      t.timestamps
    end
  end
end
