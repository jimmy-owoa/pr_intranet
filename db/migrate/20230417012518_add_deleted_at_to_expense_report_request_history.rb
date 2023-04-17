class AddDeletedAtToExpenseReportRequestHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_request_histories, :deleted_at, :datetime
  end
end
