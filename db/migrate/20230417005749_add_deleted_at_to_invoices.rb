class AddDeletedAtToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_invoices, :deleted_at, :datetime
  end
end
