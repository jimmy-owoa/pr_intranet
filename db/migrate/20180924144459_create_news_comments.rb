class CreateNewsComments < ActiveRecord::Migration[5.2]
  def change
    create_table :news_comments do |t|
      t.string :user_ip
      t.text :content
      t.boolean :approved
      t.references :post, foreign_key: {to_table: :news_posts}

      t.timestamps
    end
  end
end
