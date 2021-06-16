class AcceptInteractionsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :accept_interactions, :boolean, default: true
  end
end
