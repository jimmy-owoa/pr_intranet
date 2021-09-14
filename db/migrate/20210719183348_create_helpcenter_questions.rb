class CreateHelpcenterQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_questions do |t|
      t.string :name, default: ""
      t.text :content
      t.boolean :important, default: false
      t.references :subcategory

      t.timestamps
    end
  end
end
