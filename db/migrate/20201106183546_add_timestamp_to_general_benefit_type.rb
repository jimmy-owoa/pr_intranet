class AddTimestampToGeneralBenefitType < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefit_types, :created_at, :datetime
    add_column :general_benefit_types, :updated_at, :datetime
  end
end
