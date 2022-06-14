class CreateExpenseReportInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_invoices do |t|
      t.integer :total
      t.integer :divisa_id
      t.references :request

      t.timestamps
    end
  end
end
