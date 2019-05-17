class AddDataToSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :published_at, :datetime
    add_column :survey_surveys, :status, :string
  end
end
