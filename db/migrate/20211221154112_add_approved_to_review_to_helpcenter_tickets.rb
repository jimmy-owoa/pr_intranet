class AddApprovedToReviewToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :helpcenter_tickets, :aproved_to_review, :boolean, default: true 
  end
end
