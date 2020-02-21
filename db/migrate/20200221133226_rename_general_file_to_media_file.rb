class RenameGeneralFileToMediaFile < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :general_files, :media_files
  end

  def self.down
    rename_table :media_files, :general_files
  end
end