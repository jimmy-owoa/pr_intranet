class RemoveColumnToGeneralBenefitGroupRelationship < ActiveRecord::Migration[5.2]
  def change
    remove_column :general_benefit_group_relationships, :variable_id
  end
end
