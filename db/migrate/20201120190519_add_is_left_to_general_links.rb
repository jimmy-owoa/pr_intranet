class AddIsLeftToGeneralLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :general_links, :is_left, :boolean, default: true
    add_column :general_links, :activated, :boolean, default: true
  end
end
