class CreateGeneralUserMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :general_user_messages do |t|
      t.datetime :viewed_at
      t.references :user
      t.references :message

      t.timestamps
    end
  end
end
