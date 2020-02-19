class RenameGeneralAttachmentToMediaAttachment < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :general_attachments, :media_attachments
  end

  def self.down
    rename_table :media_attachments, :general_attachments
  end
end
