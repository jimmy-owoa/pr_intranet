class CreateEmployeeBirths < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_births do |t|
      t.string :full_name_mother
      t.string :full_name_father
      t.string :child_name
      t.string :child_lastname
      t.boolean :approved, default: false
      t.boolean :gender
      t.date :birthday

      t.timestamps
    end
  end
end
