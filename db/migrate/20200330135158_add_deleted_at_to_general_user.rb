class AddDeletedAtToGeneralUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :deleted_at, :datetime
    add_index :general_users, :deleted_at
  end
end
