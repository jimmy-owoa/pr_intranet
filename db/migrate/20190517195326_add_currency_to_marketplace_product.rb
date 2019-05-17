class AddCurrencyToMarketplaceProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :marketplace_products, :currency, :string
  end
end
