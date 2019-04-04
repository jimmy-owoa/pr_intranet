class CreateGeneralBenefitGroups < ActiveRecord::Migration[5.2]
  def change
    #relation
    add_column :general_users, :benefit_group_id, :integer
    #creation
    create_table :general_benefit_groups do |t|
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end

    create_table :general_benefit_group_relationships do |t|
      t.string :content
      t.integer :benefit_id
      t.integer :benefit_group_id

      t.timestamps
    end

  end
end
