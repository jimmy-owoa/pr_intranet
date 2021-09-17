class CreateGeneralGalleriesNewsPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :general_galleries_news_posts, id: false do |t|
      t.belongs_to :gallery, index: true
      t.belongs_to :post, index: true
    end
  end
end
