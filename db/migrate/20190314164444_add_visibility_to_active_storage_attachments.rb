class AddVisibilityToActiveStorageAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :active_storage_attachments, :permission, :integer, default: 0
  end
end
