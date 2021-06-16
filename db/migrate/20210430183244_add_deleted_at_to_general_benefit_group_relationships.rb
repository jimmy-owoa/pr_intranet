class AddDeletedAtToGeneralBenefitGroupRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefit_group_relationships, :deleted_at, :datetime
    add_index :general_benefit_group_relationships, :deleted_at
  end
end
