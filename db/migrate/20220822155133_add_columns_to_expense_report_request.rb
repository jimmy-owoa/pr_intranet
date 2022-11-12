class AddColumnsToExpenseReportRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_requests, :is_local, :boolean
    add_column :expense_report_requests , :destination_country_id, :integer
    add_column :expense_report_requests , :payment_method_id, :integer
    add_column :expense_report_requests , :bank_account_details, :string
    
  end
end
