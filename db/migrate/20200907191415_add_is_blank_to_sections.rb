class AddIsBlankToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :general_sections, :is_blank, :boolean, default: false
  end
end
