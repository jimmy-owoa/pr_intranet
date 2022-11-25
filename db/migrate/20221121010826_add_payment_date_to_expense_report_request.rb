class AddPaymentDateToExpenseReportRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_requests, :payment_date, :datetime
  end
end
