class AddXoopsTopicIdToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :xoops_topic_id, :integer
  end
end
