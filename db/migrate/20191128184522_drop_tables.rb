class DropTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :personal_data_education_institutions
    drop_table :personal_data_education_states
    drop_table :personal_data_family_members
    drop_table :personal_data_language_levels
    drop_table :personal_data_languages
  end
end
