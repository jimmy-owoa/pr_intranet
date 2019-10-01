class CreatePersonalDataHomeAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data_home_addresses do |t|
      t.string :address
      t.references :commune

      t.timestamps
    end
  end
end
