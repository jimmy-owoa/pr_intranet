class CreateUserNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :general_user_notifications do |t|
      t.datetime :seen_at
      t.datetime :opened_at
      t.integer :user_id
      t.integer :notification_id

      t.timestamps
    end
  end
end
