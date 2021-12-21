class AddApprovedToReviewToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :helpcenter_tickets, :aproved_to_review, :datetime, default: -> {'CURRENT_TIMESTAMP'}
  end
end
