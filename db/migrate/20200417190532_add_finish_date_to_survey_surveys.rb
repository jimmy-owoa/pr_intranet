class AddFinishDateToSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :finish_date, :date
  end
end
