class CreateExpenseReportCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
