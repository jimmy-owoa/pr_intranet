class AddXoopsIdToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :general_galleries, :xoops_gallery_id, :integer
    add_column :general_attachments, :xoops_attachment_id, :integer
    add_column :survey_surveys, :xoops_survey_id, :integer
  end
end
