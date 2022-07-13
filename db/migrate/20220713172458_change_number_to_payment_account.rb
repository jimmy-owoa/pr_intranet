class ChangeNumberToPaymentAccount < ActiveRecord::Migration[5.2]
  def change
    rename_column :payment_accounts, :number, :account_number
  end
end
