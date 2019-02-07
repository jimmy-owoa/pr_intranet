class AddingOptionToNewsPost < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :permission, :string
  end
end
