class AddShownameToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_surveys, :show_name, :boolean, default: true
  end
end
