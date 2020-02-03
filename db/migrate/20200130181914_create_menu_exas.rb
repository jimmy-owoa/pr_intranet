class CreateMenuExas < ActiveRecord::Migration[5.2]
  def change
    create_table :menu_exas do |t|
      t.text :body
      t.belongs_to :user
      t.timestamps
    end
  end
end
