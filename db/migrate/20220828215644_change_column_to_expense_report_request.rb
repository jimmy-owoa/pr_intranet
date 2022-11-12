class ChangeColumnToExpenseReportRequest < ActiveRecord::Migration[5.2]
  def change
    change_column :expense_report_requests, :total, :float
  end
end
