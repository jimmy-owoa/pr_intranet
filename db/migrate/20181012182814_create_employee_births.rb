class CreateEmployeeBirths < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_births do |t|
      t.string :child_name
      t.string :child_lastname
      t.string :child_lastname2
      t.boolean :approved, default: false
      t.boolean :gender
      t.date :birthday

      t.timestamps
    end
  end
end
