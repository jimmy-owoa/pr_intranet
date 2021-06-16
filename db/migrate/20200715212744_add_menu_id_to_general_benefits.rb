class AddMenuIdToGeneralBenefits < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_benefits, :menu
  end
end
