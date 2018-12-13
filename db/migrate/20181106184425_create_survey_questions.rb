class CreateSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_questions do |t|
      t.string :title
      t.text :description
      t.string :question_type
      t.references :survey

      t.timestamps
    end
  end
end
