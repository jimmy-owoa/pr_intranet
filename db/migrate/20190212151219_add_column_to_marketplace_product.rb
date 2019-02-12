class AddColumnToMarketplaceProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :marketplace_products, :is_expired, :boolean, default: false
  end
end
