class CreateGeneralUserAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :general_user_attributes do |t|
      t.integer :user_id
      t.string :attribute_name
      t.string :value

      t.timestamps
    end
  end
end
