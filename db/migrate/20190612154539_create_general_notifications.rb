class CreateGeneralNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :general_notifications do |t|
      t.string :title
      t.text :content
      t.datetime :viewed_at
      t.datetime :to_notify_at
      t.string :notification_type
      t.string :style
      t.string :link
      t.boolean :external_notification
      t.integer :user_id
      t.integer :message_id

      t.timestamps
    end
  end
end
