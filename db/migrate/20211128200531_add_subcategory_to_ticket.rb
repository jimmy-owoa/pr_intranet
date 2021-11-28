class AddSubcategoryToTicket < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :helpcenter_tickets, :subcategory
    remove_reference :helpcenter_tickets, :category
  end

  def self.down
    remove_reference :helpcenter_tickets, :subcategory
    add_reference :helpcenter_tickets, :category
  end
end
