class NewBenefitGroupRelationships < ActiveRecord::Migration[5.2]
  def change
    drop_table :general_variables
    add_column :general_benefit_group_relationships, :amount, :string
    add_column :general_benefit_group_relationships, :currency, :string
    add_column :general_benefit_group_relationships, :url, :string
  end
end
