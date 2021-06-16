class DropCommentsLegacy < ActiveRecord::Migration[5.2]
  def change
    drop_table :news_comments
  end
end
