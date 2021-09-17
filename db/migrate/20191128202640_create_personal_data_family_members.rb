class CreatePersonalDataFamilyMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_family_members do |t|
      t.string :name
      t.string :relation
      t.string :gender
      t.date :birthdate
      t.references :user

      t.timestamps
    end
  end
end
