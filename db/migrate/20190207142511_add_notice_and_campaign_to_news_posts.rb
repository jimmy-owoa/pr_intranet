class AddNoticeAndCampaignToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :post_type, :string
  end
end
