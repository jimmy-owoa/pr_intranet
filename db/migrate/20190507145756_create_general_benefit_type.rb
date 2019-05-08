class CreateGeneralBenefitType < ActiveRecord::Migration[5.2]
  def change
    create_table :general_benefit_types do |t|
      t.string :name
    end

    add_reference :general_benefits, :benefit_type, index: true
  end
end
