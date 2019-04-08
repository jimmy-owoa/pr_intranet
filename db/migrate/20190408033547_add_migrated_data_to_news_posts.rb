class AddMigratedDataToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :migrated_id, :integer
    add_column :news_posts, :migrated_image_filename, :string
  end
end