class AddDeletedAtToGeneralBenefit < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefits, :deleted_at, :datetime
    add_index :general_benefits, :deleted_at
  end
end
