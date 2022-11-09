class CreateChatMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_messages do |t|
      t.string :message
      t.references :room
      t.references :user
      t.timestamps
    end
  end
end
