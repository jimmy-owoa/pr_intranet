class AddAcceptCommentsToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :accept_comments, :boolean, default: true
  end
end
