class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :news_comments do |t|
      t.string :name, default: ""
      t.text :content
      t.references :user, null: false
      t.references :post, null: false
      t.integer :parent_comment_id

      t.timestamps
    end
  end
end
