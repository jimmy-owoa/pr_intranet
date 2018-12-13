class CreateNewsPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :news_posts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.string :status
      t.datetime :published_at
      t.references :main_image
      t.references :term
      t.integer :post_parent_id, index: true
      t.string :visibility
      t.string :post_class
      t.integer :post_order
      t.timestamps
    end
    add_foreign_key :news_posts, :general_attachments, column: :main_image_id
    add_foreign_key :news_posts, :general_terms, column: :term_id
  end
end
