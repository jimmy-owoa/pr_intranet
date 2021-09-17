class AddPostIdToGeneralGallery < ActiveRecord::Migration[5.2]
  def change
    add_column :general_galleries, :post_id, :integer
  end
end
