class AddDeletedAtToExpenseReportRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_requests, :deleted_at, :datetime
  end
end
