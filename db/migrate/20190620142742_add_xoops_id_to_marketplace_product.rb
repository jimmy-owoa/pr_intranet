class AddXoopsIdToMarketplaceProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :marketplace_products, :xoops_product_id, :integer
  end
end
