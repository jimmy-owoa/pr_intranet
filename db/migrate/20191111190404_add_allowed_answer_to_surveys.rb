class AddAllowedAnswerToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :allowed_answers, :int
  end
end
