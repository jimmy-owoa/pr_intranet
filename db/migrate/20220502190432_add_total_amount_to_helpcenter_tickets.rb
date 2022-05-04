class AddTotalAmountToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :helpcenter_tickets, :total_acount, :integer
    add_column :helpcenter_tickets, :type_of_currency, :string
  end
end
