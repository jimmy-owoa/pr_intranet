class AddCaptionToGeneralAttachment < ActiveRecord::Migration[5.2]
  def change
    add_column :general_attachments, :caption, :string
  end
end
