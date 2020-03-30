class AddDeletedAtToSurveySurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :deleted_at, :datetime
    add_index :survey_surveys, :deleted_at
  end
end
