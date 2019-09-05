class CreatePersonalDataLanguageLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_language_levels do |t|
      t.references :user
      t.references :language
      t.string :level

      t.timestamps
    end
  end
end
