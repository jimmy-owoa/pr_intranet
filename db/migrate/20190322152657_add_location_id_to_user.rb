class AddLocationIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :location_id, :integer
  end
end
