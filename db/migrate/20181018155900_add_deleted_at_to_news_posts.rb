class AddDeletedAtToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :deleted_at, :datetime
    add_index :news_posts, :deleted_at
  end
end
