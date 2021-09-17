class AddColumnToGeneralBenefitGroupRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefit_group_relationships, :variable_id, :integer

  end
end
