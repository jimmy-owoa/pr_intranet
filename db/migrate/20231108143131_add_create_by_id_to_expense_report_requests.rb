class AddCreateByIdToExpenseReportRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_requests, :created_by_id, :integer
  end
end
