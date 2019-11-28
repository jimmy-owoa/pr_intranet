class CreateGeneralUserBookRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :general_user_book_relationships do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :expiration
      t.boolean :is_expired, default: false
      t.date :request_date

      t.timestamps
    end
  end
end
