class RenameColumnAttribute < ActiveRecord::Migration[5.2]
  def change
    rename_column :general_profile_attributes, :attribute, :class_name 
  end
end
