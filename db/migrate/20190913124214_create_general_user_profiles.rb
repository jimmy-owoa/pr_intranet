class CreateGeneralUserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :general_user_profiles do |t|
      t.references :user
      t.references :profile

      t.timestamps
    end
  end
end
