class CreateExpenseReportRequestStates < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_report_request_states do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
