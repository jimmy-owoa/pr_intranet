class FixGeneralBenefitName < ActiveRecord::Migration[5.2]
  def change
    rename_column :general_variables, :general_benefit_id, :benefit_group_id
  end
end
