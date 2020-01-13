class AddFileVideoToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference :news_posts, :file_video, references: :general_attachments, index: true
    add_foreign_key :news_posts, :general_attachments, column: :file_video_id
  end
end
