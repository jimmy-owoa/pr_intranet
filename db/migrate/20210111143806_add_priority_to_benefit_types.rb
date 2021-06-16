class AddPriorityToBenefitTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefit_types, :priority, :integer, default: 1
  end
end
