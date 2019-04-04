class CreateGeneralBenefitGroupRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :general_benefit_group_relationships do |t|
      t.string :content
      t.integer :benefit_id
      t.integer :benefit_group_id

      t.timestamps
    end

  end
end
