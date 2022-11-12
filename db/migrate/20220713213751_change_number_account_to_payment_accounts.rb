class ChangeNumberAccountToPaymentAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :payment_accounts, :account_number, :string
  end
end
