class CreateSurveyOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_options do |t|
      t.string :title
      t.boolean :default
      t.string :placeholder
      t.references :question

      t.timestamps
    end
  end
end
