class CreateExpenseReportRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_requests do |t|
      t.text :description
      t.integer :total
      t.datetime :date
      t.references :user
      t.references :subcategory
      t.references :society


      t.timestamps
    end
  end
end
