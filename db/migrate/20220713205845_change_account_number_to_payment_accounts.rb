class ChangeAccountNumberToPaymentAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :payment_accounts, :account_number, :integer, limit: 8
  end
end
