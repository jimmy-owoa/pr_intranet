class AddColumnToNewsPost < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :extract, :text
  end
end
