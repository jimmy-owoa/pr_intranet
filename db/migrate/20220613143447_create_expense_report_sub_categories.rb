class CreateExpenseReportSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_subcategories do |t|
      t.string :name
      t.references :category

      t.timestamps
    end
  end
end
