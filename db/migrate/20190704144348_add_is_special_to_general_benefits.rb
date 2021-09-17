class AddIsSpecialToGeneralBenefits < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefits, :is_special, :boolean
  end
end
