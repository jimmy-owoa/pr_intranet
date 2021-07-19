class CreateMarketplaceProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :marketplace_products do |t|
      t.string :name
      t.text :description
      t.string :product_type
      t.string :currency
      t.integer :price
      t.string :email
      t.integer :phone
      t.string :location
      t.integer :expiration
      t.boolean :approved, default: false
      t.boolean :is_expired, default: false
      t.date :published_date
      t.integer :user_id

      t.timestamps
    end
  end
end
