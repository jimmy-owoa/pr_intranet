class AddTotalAmountToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :helpcenter_tickets, :amount, :integer
    add_column :helpcenter_tickets, :currency_type, :string
  end
end
