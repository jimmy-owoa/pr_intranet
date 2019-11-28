class CreatePersonalDataUserEducations < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_user_educations do |t|
      t.references :user
      t.references :education_state
      t.references :education_institution
      t.text :description

      t.timestamps
    end
  end
end
