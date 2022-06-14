class CreateExpenseReportRequestHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_request_histories do |t|
      t.references :user
      t.references :request
      t.references :request_state

      t.timestamps
    end
  end
end
