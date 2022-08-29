class ChangeColumnToExpenseReportInvoices < ActiveRecord::Migration[5.2]
  def change
    change_column :expense_report_invoices, :total, :float
  end
end
