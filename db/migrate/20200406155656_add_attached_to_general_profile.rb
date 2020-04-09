class AddAttachedToGeneralProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :general_profiles, :attached, :boolean
  end
end
