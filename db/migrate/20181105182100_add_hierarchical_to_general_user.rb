class AddHierarchicalToGeneralUser < ActiveRecord::Migration[5.2]
  def self.up
    add_column :general_users, :parent_id, :integer # Comment this line if your project already has this column
    # Category.where(parent_id: 0).update_all(parent_id: nil) # Uncomment this line if your project already has :parent_id
    add_column :general_users, :lft,       :integer
    add_column :general_users, :rgt,       :integer

    # optional fields
    add_column :general_users, :depth,          :integer
    add_column :general_users, :children_count, :integer

    # This is necessary to update :lft and :rgt columns
    General::User.reset_column_information
    General::User.rebuild!
  end

  def self.down
    remove_column :general_users, :parent_id
    remove_column :general_users, :lft
    remove_column :general_users, :rgt

    # optional fields
    remove_column :general_users, :depth
    remove_column :general_users, :children_count
  end
end
