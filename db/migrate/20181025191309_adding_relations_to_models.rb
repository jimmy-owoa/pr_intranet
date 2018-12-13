class AddingRelationsToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :marketplace_products, :user_id, :integer
    add_column :news_posts, :user_id, :integer
  end
end
