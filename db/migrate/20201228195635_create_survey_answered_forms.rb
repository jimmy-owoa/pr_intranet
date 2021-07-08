class CreateSurveyAnsweredForms < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_answered_forms do |t|
      t.references :survey
      t.references :user

      t.timestamps
    end
  end
end
