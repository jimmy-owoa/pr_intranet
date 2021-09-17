class AddCodeToGeneralBenefits < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefits, :code, :string
    add_column :general_benefits, :url, :string
  end
end
