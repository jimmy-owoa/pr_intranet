class CreateMarketplaceProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :marketplace_products do |t|
      t.string :name
      t.text :description
      t.string :product_type
      t.decimal :price, precision: 15, scale: 2
      t.string :email
      t.integer :phone
      t.string :location
      t.integer :expiration
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
