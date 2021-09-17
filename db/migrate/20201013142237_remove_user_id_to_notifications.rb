class RemoveUserIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :general_notifications, :user_id
    remove_column :general_notifications, :message_id
  end
end
