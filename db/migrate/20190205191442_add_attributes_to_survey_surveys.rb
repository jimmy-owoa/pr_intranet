class AddAttributesToSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :survey_type, :string
    add_column :survey_surveys, :slug, :string, null: true, default: nil
    add_index :survey_surveys, :slug, unique: true
  end
end
