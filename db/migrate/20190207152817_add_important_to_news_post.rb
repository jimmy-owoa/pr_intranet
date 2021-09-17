class AddImportantToNewsPost < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :important, :boolean, default: false
  end
end
