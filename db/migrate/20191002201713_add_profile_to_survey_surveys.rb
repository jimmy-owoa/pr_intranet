class AddProfileToSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    add_reference :survey_surveys, :profile
  end
end