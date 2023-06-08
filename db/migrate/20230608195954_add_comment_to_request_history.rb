class AddCommentToRequestHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_report_request_histories, :comment, :text
  end
end
