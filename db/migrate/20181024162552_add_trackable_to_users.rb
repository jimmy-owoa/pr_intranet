class AddTrackableToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :general_users do |t|
      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip      
    end
  end
end
