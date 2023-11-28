class AdAccountFromExpenseReportRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :expense_report_requests, :account
  end
end
