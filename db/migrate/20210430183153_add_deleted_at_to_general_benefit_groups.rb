class AddDeletedAtToGeneralBenefitGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefit_groups, :deleted_at, :datetime
    add_index :general_benefit_groups, :deleted_at
  end
end
