class CreateChatRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.datetime :closed_at
      t.string :resource_type
      t.integer :resource_id
      t.timestamps
    end
  end
end
