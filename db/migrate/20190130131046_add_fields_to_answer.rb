class AddFieldsToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_answers, :answer_variable, :string
  end
end
