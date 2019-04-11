class AddNewFieldsToSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :description, :text
    add_column :survey_surveys, :once_by_user, :boolean, default: true
  end
end