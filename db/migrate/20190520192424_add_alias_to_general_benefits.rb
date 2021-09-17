class AddAliasToGeneralBenefits < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefits, :alias, :string
  end
end
