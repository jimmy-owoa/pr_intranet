class ChangeTextContentToNewsPost < ActiveRecord::Migration[5.2]
  def change
    change_column :news_posts, :content, :mediumtext
  end
end
