class CreateSurveyAnsweredTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_answered_times do |t|
      t.references :survey

      t.timestamps
    end
  end
end
