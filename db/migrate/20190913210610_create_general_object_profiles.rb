class CreateGeneralObjectProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :general_object_profiles do |t|
      t.string :object
      t.integer :object_id
      t.references :profile

      t.timestamps
    end
  end
end
