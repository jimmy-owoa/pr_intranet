class CreatePersonalDataUserLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_user_languages do |t|
      t.references :user
      t.references :language
      t.references :language_level

      t.timestamps
    end
  end
end
