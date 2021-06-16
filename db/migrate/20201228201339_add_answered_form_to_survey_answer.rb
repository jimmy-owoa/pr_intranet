class AddAnsweredFormToSurveyAnswer < ActiveRecord::Migration[5.2]
  def change
    add_reference :survey_answers, :answered_form
    add_reference :general_users, :answered_form
  end
end
