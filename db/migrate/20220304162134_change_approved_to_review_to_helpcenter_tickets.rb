class ChangeApprovedToReviewToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def self.up
    change_table :helpcenter_tickets do |t|
      t.change :aproved_to_review, :boolean, default: true
    end
  end
  def self.down
    change_table :helpcenter_tickets do |t|
      t.change :aproved_to_review, :datetime
    end
  end
end
