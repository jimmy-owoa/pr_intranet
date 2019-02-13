class AddColumnToMarketplaceProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :marketplace_products, :is_expired, :boolean, default: false
    add_column :marketplace_products, :published_date, :date
  end
end
