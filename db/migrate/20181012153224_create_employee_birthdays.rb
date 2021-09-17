class CreateEmployeeBirthdays < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_birthdays do |t|

      t.timestamps
    end
  end
end
