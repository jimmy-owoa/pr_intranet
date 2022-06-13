class CreatePaymentAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_accounts do |t|
      t.string :name
      t.integer :number
      t.string :email
      t.string :legal_number
      t.string :bank_name
      t.string :account_type
      t.string :country
      t.references :user

      t.timestamps
    end
  end
end
