class CreatePersonalDataLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_languages do |t|
      t.string :name

      t.timestamps
    end
  end
end
