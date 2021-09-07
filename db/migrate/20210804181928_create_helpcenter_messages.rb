class CreateHelpcenterMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_messages do |t|
      t.text :content
      t.references :user
      t.references :ticket

      t.timestamps
    end
  end
end
