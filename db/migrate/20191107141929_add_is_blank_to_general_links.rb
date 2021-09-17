class AddIsBlankToGeneralLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :general_links, :is_blank, :boolean, default: false
  end
end
