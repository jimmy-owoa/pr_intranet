class RenameGeneralGalleryToMediaGallery < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :general_galleries, :media_galleries
    rename_table :general_galleries_news_posts, :media_galleries_news_posts
    rename_table :general_gallery_relations, :media_gallery_relations
  end

  def self.down
    rename_table :media_galleries, :general_galleries
    rename_table :media_galleries_news_posts, :general_galleries_news_posts
    rename_table :media_gallery_relations, :general_gallery_relations
  end
end
