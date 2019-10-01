class CreateGeneralProfileAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :general_profile_attributes do |t|
      t.string :attribute
      t.string :value
      t.references :profile

      t.timestamps
    end
  end
end
