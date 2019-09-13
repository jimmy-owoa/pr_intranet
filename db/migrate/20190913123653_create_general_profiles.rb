class CreateGeneralProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :general_profiles do |t|
      t.string :name

      t.timestamps
    end
  end
end
