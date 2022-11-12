class ChangeColumnSubcategoriesToInvoices < ActiveRecord::Migration[5.2]
  def change
    rename_column :expense_report_invoices, :subcategory_id, :category_id
  end
end
