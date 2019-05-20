class CreateGeneralVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :general_variables do |t|
      t.float :amount
      t.string :currency
      t.references :general_benefit, foreign_key: true

      t.timestamps
    end
  end
end
