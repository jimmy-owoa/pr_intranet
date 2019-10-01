class CreatePersonalDataFamilyMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_family_members do |t|
      t.string :name
      t.string :lastname
      t.string :relation
      t.date :birthday
      t.string :gender
      t.references :user

      t.timestamps
    end
  end
end
