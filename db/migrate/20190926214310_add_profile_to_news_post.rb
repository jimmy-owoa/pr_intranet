class AddProfileToNewsPost < ActiveRecord::Migration[5.2]
  def change
    add_reference :news_posts, :profile
  end
end
