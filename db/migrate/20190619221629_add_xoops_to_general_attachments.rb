class AddXoopsToGeneralAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :general_attachments, :xoops_attachment_name, :string
  end
end
