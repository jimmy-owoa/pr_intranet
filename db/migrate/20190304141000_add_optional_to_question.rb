class AddOptionalToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_questions, :optional, :boolean, default: false
  end
end