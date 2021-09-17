class AddFormatToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :format, :integer
  end
end
