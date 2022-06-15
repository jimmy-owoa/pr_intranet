class CreateExpenseReportRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_requests do |t|
      t.text :description
      t.integer :total
      t.datetime :date
      t.datetime :closed_at
      t.references :user
      t.references :subcategory
      t.references :society
      t.references :request_state
      t.references :assistant

      t.timestamps
    end
  end
end
